L = 1.0; // 长度
H = 0.5; // 宽度
nx = 10; // x方向网格数
ny = 5;  // y方向网格数

Point(1) = {0, 0, 0, 1.0};
Point(2) = {L, 0, 0, 1.0};
Point(3) = {L, H, 0, 1.0};
Point(4) = {0, H, 0, 1.0};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 1};

Line Loop(5) = {1, 2, 3, 4};
Plane Surface(6) = {5};

Mesh 2;
Save "mesh.msh";
