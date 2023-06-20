//よく使いそうな弾幕の
//ArrayListで作った弾ぜんぶが帰るので色とかの設定やステージに追加は自分でやる

//シンプルな全方位(angleで指定した角度を基準)
public List<Shot> circleShot(PVector pos, int way, float speed, float angle){
    return circleShot(pos, way, speed, 0f, angle);
}

//加速度付けられる版
public List<Shot> circleShot(PVector pos, int way, float speed, float accel, float angle){
    List<Shot> shots = new ArrayList<Shot>();

    for(int i = 0; i < way; i++){
        Shot s = new Shot(pos.x, pos.y);
        s.setVelocityFromSpeedAngle(speed, angle + TWO_PI / way * i);
        s.setAccelerationFromAccelAngle(accel, angle + TWO_PI / way * i);
        shots.add(s);
    }

    return shots;
}

//angleで指定した角度に向かって飛ぶnWay（扇形）弾
//gapは、1つの弾と弾の間の角度
public List<Shot> nWay(PVector pos, int way, float speed, float angle, float gap){
    return nWay(pos, way, speed, 0f, angle, gap);
}

//加速度付けられる版
public List<Shot> nWay(PVector pos, int way, float speed, float accel, float angle, float gap){
    List<Shot> shots = new ArrayList<Shot>();

    //偶数弾(外し・狙った位置は安置になる)
    if(way % 2 == 0){
        for(int i = 0; i < way / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setVelocityFromSpeedAngle(speed, angle + gap / 2 + gap * i);
            s1.setAccelerationFromAccelAngle(accel, angle + gap / 2 + gap * i);
            shots.add(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setVelocityFromSpeedAngle(speed, angle - gap / 2 - gap * i);
            s2.setAccelerationFromAccelAngle(accel, angle - gap / 2 - gap * i);
            shots.add(s2);
        }
    }
    //奇数弾（狙った位置には当たる）
    else{
        Shot s = new Shot(pos.x, pos.y);
        s.setVelocityFromSpeedAngle(speed, angle);
        s.setAccelerationFromAccelAngle(accel, angle);
        shots.add(s);

        for(int i = 0; i < (way - 1) / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setVelocityFromSpeedAngle(speed, angle + gap * (i + 1));
            s1.setAccelerationFromAccelAngle(accel, angle + gap * (i + 1));
            shots.add(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setVelocityFromSpeedAngle(speed, angle - gap * (i + 1));
            s2.setAccelerationFromAccelAngle(accel, angle - gap * (i + 1));
            shots.add(s2);
        }
    }

    return shots;
}

//線形に飛ぶ弾
public List<Shot> lineShot(PVector pos, int way, float speed, float angle, float gap){
    List<Shot> shots = new ArrayList<Shot>();

    //偶数弾(外し・狙った位置は安置になる)
    if(way % 2 == 0){
        for(int i = 0; i < way / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setVelocityFromSpeedAngle(speed / cos(gap / 2 + gap * i), angle + gap / 2 + gap * i);
            shots.add(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setVelocityFromSpeedAngle(speed / cos(gap / 2 + gap * i), angle - gap / 2 - gap * i);
            shots.add(s2);
        }
    }
    //奇数弾（狙った位置には当たる）
    else{
        Shot s = new Shot(pos.x, pos.y);
        s.setVelocityFromSpeedAngle(speed, angle);
        shots.add(s);

        for(int i = 0; i < (way - 1) / 2; i++){
            Shot s1 = new Shot(pos.x, pos.y);
            s1.setVelocityFromSpeedAngle(speed / cos(gap * (i + 1)), angle + gap * (i + 1));
            shots.add(s1);

            Shot s2 = new Shot(pos.x, pos.y);
            s2.setVelocityFromSpeedAngle(speed / cos(gap * (i + 1)), angle - gap * (i + 1));
            shots.add(s2);
        }
    }
    return shots;
}