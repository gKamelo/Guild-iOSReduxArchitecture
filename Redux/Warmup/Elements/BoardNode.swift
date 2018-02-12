//
//  BoardNode.swift
//  Warmup
//
//  Copyright © 2018 Oink oink. All rights reserved.
//

import SpriteKit

protocol BoardActionDelegate: class {

    func boardAction(at field: BoardNode.Field)
}

final class BoardNode: SKNode {

    private struct Constant {

        static let boardFields = 3
        static let boardLine = CGFloat(3)
    }

    struct Field: Hashable {

        static func == (lhs: BoardNode.Field, rhs: BoardNode.Field) -> Bool {
            return lhs.column == rhs.column && lhs.row == rhs.row
        }

        var hashValue: Int {
            return self.column ^ self.row
        }

        let column: Int
        let row: Int
    }

    private weak var currentTouch: UITouch?

    private var marks = [Field: SKNode]()

    private let frameShape: SKShapeNode
    private let verticalLines: [SKSpriteNode]
    private let horizontalLines: [SKSpriteNode]

    private let cellSize: CGFloat

    weak var actionDelegate: BoardActionDelegate?

    init(cellSize: CGFloat) {
        let fullSize = CGSize(width: cellSize * CGFloat(Constant.boardFields), height: cellSize * CGFloat(Constant.boardFields))

        self.frameShape = SKShapeNode(rect: CGRect(origin: .zero, size: fullSize))
        self.horizontalLines = (0 ..< Constant.boardFields - 1).map { _ in SKSpriteNode(color: .white, size: CGSize(width: Constant.boardLine, height: CGFloat(Constant.boardFields) * cellSize)) }
        self.verticalLines = (0 ..< Constant.boardFields - 1).map { _ in SKSpriteNode(color: .white, size: CGSize(width: CGFloat(Constant.boardFields) * cellSize, height: Constant.boardLine)) }

        self.cellSize = cellSize

        super.init()

        self.build()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal setup
    private func build() {
        self.frameShape.lineWidth = Constant.boardLine

        (1 ..< Constant.boardFields).forEach { index in
            let hLine = self.horizontalLines[index - 1]
            let vLine = self.verticalLines[index - 1]

            hLine.position = CGPoint(x: CGFloat(index) * self.cellSize, y: 0)
            hLine.anchorPoint = .zero

            vLine.position = CGPoint(x: 0, y: CGFloat(index) * self.cellSize)
            vLine.anchorPoint = .zero

            self.addChild(hLine)
            self.addChild(vLine)
        }

        self.addChild(self.frameShape)
    }

    // MARK: - What we can ;)
    func put(into field: Field, a mark: SKNode) {
        // MARK: Secure outbounds
        guard self.marks[field] == nil else { return }

        mark.position = CGPoint(x: CGFloat(field.column) * self.cellSize, y: CGFloat(field.row) * self.cellSize)

        self.marks[field] = mark
        self.addChild(mark)
    }

    func clean() {
        self.marks.forEach { $0.value.removeFromParent() }
        self.marks.removeAll()
    }

    // MARK: - Touch handling
    private func field(for touch: UITouch) -> Field? {
        let touchLocation = touch.location(in: self)

        if 0 < touchLocation.x && touchLocation.x < self.cellSize * CGFloat(Constant.boardFields)
            && 0 < touchLocation.y && touchLocation.y < self.cellSize * CGFloat(Constant.boardFields) {
            let column = Int(touchLocation.x / self.cellSize)
            let row = Int(touchLocation.y / self.cellSize)
            let field = Field(column: column, row: row)

            return self.marks[field] == nil ? field : nil
        }

        return nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentTouch = touches.first
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch == self.currentTouch,
            let field = self.field(for: touch) else { return }

        self.actionDelegate?.boardAction(at: field)
    }
}
