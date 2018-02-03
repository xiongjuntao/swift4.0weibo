-- 创建微博数据表 --
CREATE TABLE IF NOT EXISTS "T_Status" (
    "statusId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "status" TEXT,
    "createTime" TEXT DEFAULT (datetime('now', 'localtime')),
    PRIMARY KEY("statusId","userId")
);
