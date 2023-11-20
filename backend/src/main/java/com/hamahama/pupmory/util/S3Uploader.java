package com.hamahama.pupmory.util;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.amazonaws.services.s3.model.ObjectMetadata;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.PutObjectRequest;
import lombok.RequiredArgsConstructor;


@Slf4j
@RequiredArgsConstructor
@Component
public class S3Uploader {
    private final AmazonS3Client amazonS3Client;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    public List<String> upload(List<MultipartFile> mfileList, String dirName, String userUid) throws IOException {
        List<String> fileUrlList = new ArrayList<String>();

        for (MultipartFile mfile : mfileList) {
            ObjectMetadata objectMetadata = generateObjectMetaData(mfile);
            String imageKey = dirName + "/" + userUid + "/" + UUID.randomUUID();

            // aws-java-sdk-bom 구버전 쓰면 PutObjectRequest 파라미터가 3개짜리임
            amazonS3Client.putObject(new PutObjectRequest(bucket, imageKey, mfile.getInputStream(), objectMetadata)
                    .withCannedAcl(CannedAccessControlList.PublicRead));

            String uploadImageUrl = amazonS3Client.getUrl(bucket, imageKey).toString();
            fileUrlList.add(uploadImageUrl);
        }
        return fileUrlList;
    }

    private ObjectMetadata generateObjectMetaData(MultipartFile file) {
        ObjectMetadata objectMetadata = new ObjectMetadata();
        objectMetadata.setContentLength(file.getSize());
        objectMetadata.setContentType(file.getContentType());
        return objectMetadata;
    }
}