# PSAddressEdit_CreateOrModify

## Purpose

>>> 新增或修改用户地址


## instruction

>>> * Model      ：每一级对应的地址名、id、对应上一级地址id（初始默认为0）
>>> * View         ：可根据自身需要重新搭建  -- 仿淘宝
>>> * Controller ：可根据自身需要重新搭建
>>> * Resources：所需图片、.pch文件、存储地址的plist文件

## Installation & Usage
>>> * 1、将 "VictoriaAddress" 放入所想要的项目目录
>>> * 2、查看 "TARGETS" -> "Build Phases" -> "Compile Sources" ：确认VictoriaAddress中的.m文件是否add了
>>> * 3、查看 "TARGETS" -> "Build Phases" -> "Copy Bundle Resources" ，导入所需的资源(所需图片、.pch文件、存储地址的plist文件)，这一步很重要
>>> * 3(1)  Resources中的图片可添加到你原有项目的图片资源里，例如：Assets.xcassets
>>> * 3(2) Resources中的.pch文件可整合到你原有项目的的.pch文件里，例如：Assets.xcassets
>>> * 3(3) Resources中的plist文件可复制到你新创建的plist文件里
