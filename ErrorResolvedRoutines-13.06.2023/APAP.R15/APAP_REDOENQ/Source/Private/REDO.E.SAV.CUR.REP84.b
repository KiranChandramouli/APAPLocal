* @ValidationCode : Mjo5MjIyMjE1NzQ6Q3AxMjUyOjE2ODIwNzMzODM1NDI6SVRTUzotMTotMTotMTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -11
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.SAV.CUR.REP84(ENQ.DATA)

*M o d i f i c a t i o n  H i s t o r y :
*----------------------------------------
*   Date        Author             Modification Description
*
* 23-Feb-2015   V.P.Ashokkumar     PACS00309822 - Added the category
*
* 17-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

INITIALISE:

RETURN

PROCESS:

    SEL.CMD = "SELECT F.CATEGORY WITH @ID GE 1000 AND LE 1999"
    CALL EB.READLIST(SEL.CMD,SEL.LIST," ",NO.OF.RECS,SEL.ERR)

    SEL.CMD1 = "SELECT F.CATEGORY WITH @ID GE 6001 AND LE 6099"
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1," ",NO.OF.RECS1,SEL.ERR1)

    SEL.CMD2 = "SELECT F.CATEGORY WITH @ID GE 6501 AND LE 6599"
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2," ",NO.OF.RECS2,SEL.ERR2)

    CATEGORY.LIST = SEL.LIST:@VM:SEL.LIST1:@VM:SEL.LIST2

    LOOP
        REMOVE CATEGORY.ID FROM CATEGORY.LIST SETTING CATEG.POS
    WHILE CATEGORY.ID:CATEG.POS

        IF CATEGORY.ID GE 6013 AND CATEGORY.ID LE 6020 ELSE
            FINAL.CATEG.LIST<-1> = CATEGORY.ID
        END

    REPEAT

    IF FINAL.CATEG.LIST THEN
        FINAL.CATEG.LIST = CHANGE(FINAL.CATEG.LIST,@FM," ")
        ENQ.DATA<2,1> = "@ID"
        ENQ.DATA<3,1> = "EQ"
        ENQ.DATA<4,1> = FINAL.CATEG.LIST
    END

RETURN
*******
END
