function visualizeDisplacement(nodeCoordinates, U)
    % nodeCoordinates 是节点坐标
    % U 是位移向量

    displacedCoordinates = nodeCoordinates + reshape(U, [], 2);  % 计算位移后的坐标

    figure;
    hold on;
    plot(nodeCoordinates(:, 1), nodeCoordinates(:, 2), 'ro', 'MarkerFaceColor', 'r'); % 原始节点
    plot(displacedCoordinates(:, 1), displacedCoordinates(:, 2), 'bo', 'MarkerFaceColor', 'b'); % 位移后节点
    xlabel('x');
    ylabel('y');
    title('位移场');
    axis equal;
    grid on;
    hold off;
end
