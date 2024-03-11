# OCOCO

**漬け物のレシピ・熟成過程記録サービス**

デモサイト: https://ococo.onrender.com  
デモユーザー:
* ユーザーID: mochibanana
* パスワード: password1234

## 機能
* ユーザーの作成・ログイン
* 漬け物レシピの作成・編集・閲覧・削除
* 漬け物ごとの熟成過程をマイクロポストとして投稿・閲覧・削除

## 開発技術
* Ruby 3.2.2
* Ruby on Rails 7.1.1

* Bootsrtap 5.3.2

* PostgreSQL 15 (Renderでは16)

* Docker

* RSpec
  * Model Spec
  * System Spec

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## ER図
```mermaid
erDiagram
    %% --------------------------------------------------------
    %% Generated by "Rails Mermaid ERD"
    %% https://github.com/koedame/rails-mermaid_erd
    %% Restore Hash: #eyJzZWxlY3RNb2RlbHMiOlsiQWN0aXZlU3RvcmFnZTo6QXR0YWNobWVudCIsIkFjdGl2ZVN0b3JhZ2U6OkJsb2IiLCJBY3RpdmVTdG9yYWdlOjpWYXJpYW50UmVjb3JkIiwiSW5ncmVkaWVudCIsIkpvdXJuYWwiLCJQaWNrbGUiLCJQcm9maWxlIiwiU2F1Y2VNYXRlcmlhbCIsIlVzZXIiXSwiaXNQcmV2aWV3UmVsYXRpb25zIjpmYWxzZSwiaXNTaG93UmVsYXRpb25Db21tZW50IjpmYWxzZSwiaXNTaG93S2V5Ijp0cnVlLCJpc1Nob3dDb21tZW50IjpmYWxzZSwiaXNIaWRlQ29sdW1ucyI6ZmFsc2V9
    %% --------------------------------------------------------

    %% table name: active_storage_attachments
    ActiveStorage--Attachment {
        integer id PK 
        string name  
        string record_type  
        integer record_id  
        integer blob_id FK 
        datetime created_at  
    }

    %% table name: active_storage_blobs
    ActiveStorage--Blob {
        integer id PK 
        string key  
        string filename  
        string content_type  
        text metadata  
        string service_name  
        integer byte_size  
        string checksum  
        datetime created_at  
    }

    %% table name: active_storage_variant_records
    ActiveStorage--VariantRecord {
        integer id PK 
        integer blob_id FK 
        string variation_digest  
    }

    %% table name: ingredients
    Ingredient {
        integer id PK 
        integer pickle_id FK 
        string name  
        string quantity  
        datetime created_at  
        datetime updated_at  
    }

    %% table name: journals
    Journal {
        integer id PK 
        integer pickle_id FK 
        text body  
        datetime created_at  
        datetime updated_at  
    }

    %% table name: pickles
    Pickle {
        integer id PK 
        integer user_id  
        string name  
        date started_on  
        datetime created_at  
        datetime updated_at  
        text preparation  
        text process  
        text note  
    }

    %% table name: profiles
    Profile {
        integer id PK 
        integer user_id  
        string display_name  
        integer prefecture  
        datetime created_at  
        datetime updated_at  
        text description  
        text x_username  
        text ig_username  
    }

    %% table name: sauce_materials
    SauceMaterial {
        integer id PK 
        integer pickle_id FK 
        string name  
        string quantity  
        datetime created_at  
        datetime updated_at  
    }

    %% table name: users
    User {
        integer id PK 
        string username  
        string email  
        string encrypted_password  
        string reset_password_token  
        datetime reset_password_sent_at  
        datetime remember_created_at  
        integer sign_in_count  
        datetime current_sign_in_at  
        datetime last_sign_in_at  
        string current_sign_in_ip  
        string last_sign_in_ip  
        string confirmation_token  
        datetime confirmed_at  
        datetime confirmation_sent_at  
        string unconfirmed_email  
        integer failed_attempts  
        string unlock_token  
        datetime locked_at  
        datetime created_at  
        datetime updated_at  
    }

    ActiveStorage--Attachment |o--|| ActiveStorage--Blob : ""
    ActiveStorage--Blob ||--o{ ActiveStorage--VariantRecord : ""
    ActiveStorage--Blob }o..o| ActiveStorage--Blob : ""
    ActiveStorage--VariantRecord ||--o| ActiveStorage--Attachment : ""
    ActiveStorage--VariantRecord }o..o| ActiveStorage--Blob : ""
    Ingredient }o--|| Pickle : ""
    Journal }o--|| Pickle : ""
    Journal }o..o| User : ""
    Pickle ||--o{ SauceMaterial : ""
    Pickle }o--|| User : ""
    Profile |o--|| User : ""
    Profile ||--o| ActiveStorage--Attachment : ""
    Profile }o..o| ActiveStorage--Blob : ""
```

## 追加予定の機能
* 既存の漬け物のレシピを引用する形で漬け物を新規作成する
* レシピを文字列検索する
* 漬け物の記録の投稿時に画像を添付する
* ユーザーをフォローしてフィードを表示する
* 漬け物の記録にコメントを残す