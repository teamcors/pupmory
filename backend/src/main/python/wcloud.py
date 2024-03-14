#-*-coding:utf-8-*-

import sys
from collections import defaultdict, Counter
from konlpy.tag import Okt
import json
from pika import BlockingConnection, BasicProperties


sample_text = """
교육의 자주성·전문성·정치적 중립성 및 대학의 자율성은 법률이 정하는 바에 의하여 보장된다. 헌법재판소는 법률에 저촉되지 아니하는 범위안에서 심판에 관한 절차, 내부규율과 사무처리에 관한 규칙을 제정할 수 있다.
헌법재판소에서 법률의 위헌결정, 탄핵의 결정, 정당해산의 결정 또는 헌법소원에 관한 인용결정을 할 때에는 재판관 6인 이상의 찬성이 있어야 한다. 헌법개정은 국회재적의원 과반수 또는 대통령의 발의로 제안된다.
국무회의는 대통령·국무총리와 15인 이상 30인 이하의 국무위원으로 구성한다. 헌법재판소 재판관은 탄핵 또는 금고 이상의 형의 선고에 의하지 아니하고는 파면되지 아니한다.
나는 헌법을 준수하고 국가를 보위하며 조국의 평화적 통일과 국민의 자유와 복리의 증진 및 민족문화의 창달에 노력하여 대통령으로서의 직책을 성실히 수행할 것을 국민 앞에 엄숙히 선서합니다.
대통령은 조약을 체결·비준하고, 외교사절을 신임·접수 또는 파견하며, 선전포고와 강화를 한다. 의무교육은 무상으로 한다. 타인의 범죄행위로 인하여 생명·신체에 대한 피해를 받은 국민은 법률이 정하는 바에 의하여 국가로부터 구조를 받을 수 있다.
언론·출판에 대한 허가나 검열과 집회·결사에 대한 허가는 인정되지 아니한다. 국회의원은 현행범인인 경우를 제외하고는 회기중 국회의 동의없이 체포 또는 구금되지 아니한다.
모든 국민은 헌법과 법률이 정한 법관에 의하여 법률에 의한 재판을 받을 권리를 가진다. 탄핵소추의 의결을 받은 자는 탄핵심판이 있을 때까지 그 권한행사가 정지된다.
혼인과 가족생활은 개인의 존엄과 양성의 평등을 기초로 성립되고 유지되어야 하며, 국가는 이를 보장한다. 예비비는 총액으로 국회의 의결을 얻어야 한다. 예비비의 지출은 차기국회의 승인을 얻어야 한다.
대통령의 선거에 관한 사항은 법률로 정한다. 대법원은 법률에 저촉되지 아니하는 범위안에서 소송에 관한 절차, 법원의 내부규율과 사무처리에 관한 규칙을 제정할 수 있다.
국가는 대외무역을 육성하며, 이를 규제·조정할 수 있다. 헌법재판소는 법관의 자격을 가진 9인의 재판관으로 구성하며, 재판관은 대통령이 임명한다. 모든 국민은 사생활의 비밀과 자유를 침해받지 아니한다.
"""

def on_wcgen_published(channel, method_frame, header_frame, body):
    label = method_frame.routing_key
    print('* * * WcGen 메시지 수신')
    print('label:', label)
    print('body:', body.decode())

    channel.basic_ack(delivery_tag=method_frame.delivery_tag)

# refactor 후: publishWcGenMessage 방식
connection = BlockingConnection()
channel = connection.channel()
channel.basic_consume(queue='pupmory.wcgen', on_message_callback=on_wcgen_published)

def generate(sentence, prev_data):
    # logging inputs
    sys.stderr.reconfigure(encoding="utf-8")
    sys.stderr.write('prev_data: ' + prev_data)

    okt = Okt()
    nouns = okt.nouns(sentence) # 명사만 추출

    words = [n for n in nouns if len(n) > 1] # 단어의 길이가 1개인 것은 제외
    counter = Counter(words) # 위에서 얻은 words를 처리하여 단어별 빈도수 형태의 딕셔너리 데이터를 구함

    # 결과를 dictionary로 작성
    # [{'word': key, 'value': value}] 형태의 dictionary list로 작성하지 않는 이유:
    # 그렇게 하면 합산할 때 O(N^2)이 됨
    new_dict = defaultdict(int) # 합산시 존재하지 않는 key는 기본 0에서 시작
    for key, value in counter.items():
        new_dict[key] = value

    # 이전 데이터를 dictionary로 파싱
    # 이전 데이터란 DB에 저장되어있던 데이터로, json list로 저장되어 있음
    prev_json_list = json.loads(prev_data)
    prev_dict = {}
    for jdata in prev_json_list:
        key, value = list(jdata.values())
        prev_dict[key] = value

    # 결과 합산
    for key, value in prev_dict.items():
        new_dict[key] += value

    # 합산된 dictionary를 내림차순 정렬
    # This requires Python 3.7+
    new_dict = dict(sorted(new_dict.items(), key=lambda x: x[1], reverse=True))

    # 정렬한 dictionary를 json list 형태의 string으로 작성
    # 한글 인코딩을 \u 포맷으로 만들어버리는 문제가 있어 json.dumps()는 사용하지 않음
    result_str = '['
    for key, value in new_dict.items():
        data_str = '{"word": "' + key + '", "value": ' + str(value) + '}, '
        result_str += data_str

    result_str = result_str[:-2] + ']'

    # 결과 반환
    # UTF-8 출력 강제
    sys.stdout.buffer.write(result_str.encode('utf8'))


if __name__ == "__main__":
    # legacy: saveWordCloudExec 방식
    # generate(sys.argv[1], sys.argv[2])

    # refactor 후: publishWcGenMessage 방식
    try:
        channel.start_consuming()
    except KeyboardInterrupt:
        channel.stop_consuming()

    connection.close()