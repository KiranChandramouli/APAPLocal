* @ValidationCode : MjotNzg5MDU4MjUwOkNwMTI1MjoxNjgyMzE1ODIzNDY0OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:27:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.WRITE.FILE(ARR)
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.WRITE.FILE
* Date           : 2018-09-17
* Item ID        : ----------
*========================================================================
* Brief description :
* -------------------
* This program allow you create any type of file in any path that has been
* previously specified in your code. in case that you don't do that, the
* resulting file will be create under ; "../bnk.interface".
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-09-17     Richard HC        Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :N/A
* Auto Increment :N/A
* Views/versions :N/A
* EB record      :LAPAP.WRITE.FILE
* Routine        :LAPAP.WRITE.FILE
*========================================================================

****    D O  N O T  M O D I F Y  T H I S  R O U T I N E    ****

* A lot of requeriments could be depending to this program if you unknown
* all of those previous soluctions, take as sugerence doesn't edit any
* fragment of code content here. In case that you need solve particular
* cases, please kindly create a new soluction independent to this one.
*------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE     ;*R22 AUTO CODE CONVERSION


    FILE = ARR<1> ;* File name to create
    INFO = ARR<2> ;* Information to will written
    PATH = ARR<3> ;* path to create file

    IF PATH EQ "" THEN
        PATH = "../bnk.interface"
    END

    OPENSEQ PATH,FILE TO F.FILE.OUT THEN NULL
    WRITESEQ INFO APPEND TO F.FILE.OUT ELSE
        CRT 'HAVE A PROBLEM TRYING TO WRITE FILE'
        STOP
    END

RETURN

END
