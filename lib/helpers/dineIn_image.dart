class DineInImageSetup {
  static List<TableImage> tablesImages = List<TableImage>.empty(growable: true);
  static List<TableImage> getImages() {
    if (tablesImages.length == 0) {
      _loadImages();
    }
    return tablesImages;
  }

  static void _loadImages() {
    tablesImages = List<TableImage>.empty(growable: true);

    TableImage table;
    //1 Person Square Table
    table = new TableImage();
    table.type = 1;
    table.width = 100;
    table.height = 80;
    table.margin = "35,5,30,0";
    table.image_green = "assets/Tables/1_Person/1_Person_S_G.png";
    table.image_red = "assets/Tables/1_Person/1_Person_S_R.png";
    table.image_white = "assets/Tables/1_Person/1_Person_S_W.png";
    table.image_yello = "assets/Tables/1_Person/1_Person_S_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //2 Person Square Table
    table = new TableImage();
    table.type = 2;
    table.width = 110;
    table.height = 70;
    table.margin = "45,0,45,0";
    table.image_green = "assets/Tables/2_Persons/2_Person_S_G.png";
    table.image_red = "assets/Tables/2_Persons/2_Person_S_R.png";
    table.image_white = "assets/Tables/2_Persons/2_Person_S_W.png";
    table.image_yello = "assets/Tables/2_Persons/2_Person_S_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //2 Person Circle Table
    table = new TableImage();
    table.type = 3;
    table.width = 112;
    table.height = 82;
    table.margin = "30,0,30,0";
    table.image_green = "assets/Tables/2_Persons/2_Person_C_G.png";
    table.image_red = "assets/Tables/2_Persons/2_Person_C_R.png";
    table.image_white = "assets/Tables/2_Persons/2_Person_C_W.png";
    table.image_yello = "assets/Tables/2_Persons/2_Person_C_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //4 Person Square Table
    table = new TableImage();
    table.type = 4;
    table.width = 112;
    table.height = 110;
    table.margin = "30,0,30,0";
    table.image_green = "assets/Tables/4_Persons/4_Person_S_G.png";
    table.image_red = "assets/Tables/4_Persons/4_Person_S_R.png";
    table.image_white = "assets/Tables/4_Persons/4_Person_S_W.png";
    table.image_yello = "assets/Tables/4_Persons/4_Person_S_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //4 Person Round Table
    table = new TableImage();
    table.type = 5;
    table.width = 128;
    table.height = 110;
    table.margin = "32,0,32,0";
    table.image_green = "assets/Tables/4_Persons/4_Person_R_G.png";
    table.image_red = "assets/Tables/4_Persons/4_Person_R_R.png";
    table.image_white = "assets/Tables/4_Persons/4_Person_R_W.png";
    table.image_yello = "assets/Tables/4_Persons/4_Person_R_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //4 Person Circle Table
    table = new TableImage();
    table.type = 6;
    table.width = 112;
    table.height = 110;
    table.margin = "30,0,30,0";
    table.image_green = "assets/Tables/4_Persons/4_Person_C_G.png";
    table.image_red = "assets/Tables/4_Persons/4_Person_C_R.png";
    table.image_white = "assets/Tables/4_Persons/4_Person_C_W.png";
    table.image_yello = "assets/Tables/4_Persons/4_Person_C_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //6 Person Round Table
    table = new TableImage();
    table.type = 7;
    table.width = 160;
    table.height = 110;
    table.margin = "35,25,35,25";
    table.image_green = "assets/Tables/6_Persons/6_Persons_R_G.png";
    table.image_red = "assets/Tables/6_Persons/6_Persons_R_R.png";
    table.image_white = "assets/Tables/6_Persons/6_Persons_R_W.png";
    table.image_yello = "assets/Tables/6_Persons/6_Persons_R_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //6 Person Round 2 Table
    table = new TableImage();
    table.type = 8;
    table.width = 160;
    table.height = 110;
    table.margin = "35,25,35,25";
    table.image_green = "assets/Tables/6_Persons/6_Persons_R2_G.png";
    table.image_red = "assets/Tables/6_Persons/6_Persons_R2_R.png";
    table.image_white = "assets/Tables/6_Persons/6_Persons_R2_W.png";
    table.image_yello = "assets/Tables/6_Persons/6_Persons_R2_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //6 Person Circle Table
    table = new TableImage();
    table.type = 9;
    table.width = 160;
    table.height = 153;
    table.margin = "35,25,35,25";
    table.image_green = "assets/Tables/6_Persons/6_Persons_C_G.png";
    table.image_red = "assets/Tables/6_Persons/6_Persons_C_R.png";
    table.image_white = "assets/Tables/6_Persons/6_Persons_C_W.png";
    table.image_yello = "assets/Tables/6_Persons/6_Persons_C_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //8 Person Round Table
    table = new TableImage();
    table.type = 10;
    table.width = 192;
    table.height = 112;
    table.margin = "35,25,35,25";
    table.image_green = "assets/Tables/8_Persons/8_Persons_R_G.png";
    table.image_red = "assets/Tables/8_Persons/8_Persons_R_R.png";
    table.image_white = "assets/Tables/8_Persons/8_Persons_R_W.png";
    table.image_yello = "assets/Tables/8_Persons/8_Persons_R_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //8 Person Round 2 Table
    table = new TableImage();
    table.type = 11;
    table.width = 220;
    table.height = 114;
    table.margin = "5,30,5,30";
    table.image_green = "assets/Tables/8_Persons/8_Persons_R2_G.png";
    table.image_red = "assets/Tables/8_Persons/8_Persons_R2_R.png";
    table.image_white = "assets/Tables/8_Persons/8_Persons_R2_W.png";
    table.image_yello = "assets/Tables/8_Persons/8_Persons_R2_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //8 Person Circle Table
    table = new TableImage();
    table.type = 12;
    table.width = 176;
    table.height = 175;
    table.margin = "25,25,25,25";
    table.image_green = "assets/Tables/8_Persons/8_Persons_C_G.png";
    table.image_red = "assets/Tables/8_Persons/8_Persons_C_R.png";
    table.image_white = "assets/Tables/8_Persons/8_Persons_C_W.png";
    table.image_yello = "assets/Tables/8_Persons/8_Persons_C_Y.png";
    table.isSelected = false;
    tablesImages.add(table);

    //10 Person Round Table
    table = new TableImage();
    table.type = 13;
    table.width = 235;
    table.height = 114;
    table.margin = "35,25,35,25";
    table.image_green = "assets/Tables/10_Persons/10_Persons_R_G.png";
    table.image_red = "assets/Tables/10_Persons/10_Persons_R_R.png";
    table.image_white = "assets/Tables/10_Persons/10_Persons_R_W.png";
    table.image_yello = "assets/Tables/10_Persons/10_Persons_R_Y.png";
    table.isSelected = false;
    tablesImages.add(table);
  }
}

class TableImage {
  int? type;
  double? width;
  double? height;
  String? margin;
  bool? isSelected;
  String? image_green;
  String? image_red;
  String? image_white;
  String? image_yello;
}
