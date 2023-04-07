//よく使いそうな弾幕の

//シンプルな全方位(angleで指定した角度を基準)
public void circleShot(Stage stage, PVector pos, int way, float speed, float angle){
    for(int i = 0; i < way; i++){
        Shot s = new Shot(pos.x, pos.y);
        s.setDelay(15);
        s.setSize(8);
        s.setColor(col);
        s.setVelocityFromSpeedAngle(speed, angle + TWO_PI / way * i);
        stage.addEnemyShot(s);
    }
}

//加速度付けられる版
public void circleShot(Stage stage, PVector pos, int way, float speed, float accel, float angle, color col){
    for(int i = 0; i < way; i++){
        Shot s = new Shot(pos.x, pos.y);
        s.setDelay(15);
        s.setSize(8);
        s.setColor(col);
        s.setVelocityFromSpeedAngle(speed, angle + TWO_PI / way * i);
        s.setAccelerationFromAccelAngle(accel, angle + TWO_PI / way * i);
        stage.addEnemyShot(s);
    }
}

//angleで指定した角度に向かって飛ぶnWay（扇形）弾
//gapは、1つの弾と弾の間の角度
public void nWay(Stage stage, PVector pos, int way, float speed, float angle, float gap, color col){
    //偶数弾(外し・狙った位置は安置になる)
    if(way % 2 == 0){
        for(int i = 0; i < way / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setDelay(15);
            s1.setSize(8);
            s1.setColor(col);
            s1.setVelocityFromSpeedAngle(speed, angle + gap / 2 + gap * i);
            stage.addEnemyShot(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setDelay(15);
            s2.setSize(8);
            s2.setColor(col);
            s2.setVelocityFromSpeedAngle(speed, angle - gap / 2 - gap * i);
            stage.addEnemyShot(s2);
        }
    }
    //奇数弾（狙った位置には当たる）
    else{
        Shot s = new Shot(pos.x, pos.y);
        s.setDelay(15);
        s.setSize(8);
        s.setColor(col);
        s.setVelocityFromSpeedAngle(speed, angle);
        stage.addEnemyShot(s);

        for(int i = 0; i < (way - 1) / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setDelay(15);
            s1.setSize(8);
            s1.setColor(col);
            s1.setVelocityFromSpeedAngle(speed, angle + gap * (i + 1));
            stage.addEnemyShot(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setDelay(15);
            s2.setSize(8);
            s2.setColor(col);
            s2.setVelocityFromSpeedAngle(speed, angle - gap * (i + 1));
            stage.addEnemyShot(s2);
        }
    }
}

//加速度付けられる版
public void nWay(Stage stage, PVector pos, int way, float speed, float accel, float angle, float gap, color col){
    //偶数弾(外し・狙った位置は安置になる)
    if(way % 2 == 0){
        for(int i = 0; i < way / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setDelay(15);
            s1.setSize(8);
            s1.setColor(col);
            s1.setVelocityFromSpeedAngle(speed, angle + gap / 2 + gap * i);
            s1.setAccelerationFromAccelAngle(accel, angle + gap / 2 + gap * i);
            stage.addEnemyShot(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setDelay(15);
            s2.setSize(8);
            s2.setColor(col);
            s2.setVelocityFromSpeedAngle(speed, angle - gap / 2 - gap * i);
            s2.setAccelerationFromAccelAngle(accel, angle - gap / 2 - gap * i);
            stage.addEnemyShot(s2);
        }
    }
    //奇数弾（狙った位置には当たる）
    else{
        Shot s = new Shot(pos.x, pos.y);
        s.setDelay(15);
        s.setSize(8);
        s.setColor(col);
        s.setVelocityFromSpeedAngle(speed, angle);
        s.setAccelerationFromAccelAngle(accel, angle);
        stage.addEnemyShot(s);

        for(int i = 0; i < (way - 1) / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setDelay(15);
            s1.setSize(8);
            s1.setColor(col);
            s1.setVelocityFromSpeedAngle(speed, angle + gap * (i + 1));
            s1.setAccelerationFromAccelAngle(accel, angle + gap * (i + 1));
            stage.addEnemyShot(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setDelay(15);
            s2.setSize(8);
            s2.setColor(col);
            s2.setVelocityFromSpeedAngle(speed, angle - gap * (i + 1));
            s2.setAccelerationFromAccelAngle(accel, angle - gap * (i + 1));
            stage.addEnemyShot(s2);
        }
    }
}


//線形に飛ぶ弾
public void lineShot(Stage stage, PVector pos, int way, float speed, float angle, float gap, color col){
    //偶数弾(外し・狙った位置は安置になる)
    if(way % 2 == 0){
        for(int i = 0; i < way / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setDelay(15);
            s1.setSize(8);
            s1.setColor(col);
            s1.setVelocityFromSpeedAngle(speed / cos(gap / 2 + gap * i), angle + gap / 2 + gap * i);
            stage.addEnemyShot(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setDelay(15);
            s2.setSize(8);
            s2.setColor(col);
            s2.setVelocityFromSpeedAngle(speed / cos(gap / 2 + gap * i), angle - gap / 2 - gap * i);
            stage.addEnemyShot(s2);
        }
    }
    //奇数弾（狙った位置には当たる）
    else{
        Shot s = new Shot(pos.x, pos.y);
        s.setDelay(15);
        s.setSize(8);
        s.setColor(col);
        s.setVelocityFromSpeedAngle(speed, angle);
        stage.addEnemyShot(s);

        for(int i = 0; i < (way - 1) / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setDelay(15);
            s1.setSize(8);
            s1.setColor(col);
            s1.setVelocityFromSpeedAngle(speed / cos(gap * (i + 1)), angle + gap * (i + 1));
            stage.addEnemyShot(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setDelay(15);
            s2.setSize(8);
            s2.setColor(col);
            s2.setVelocityFromSpeedAngle(speed / cos(gap * (i + 1)), angle - gap * (i + 1));
            stage.addEnemyShot(s2);
        }
    }
}