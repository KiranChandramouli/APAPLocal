* @ValidationCode : MjotMTYxNTExNjA5MTpVVEYtODoxNzA1ODk5NTcxMTY2OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Jan 2024 10:29:31
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE E.BUILD.STMT.MON.RPT(ENQUIRY.1.DATA)
*-------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : E.BUILD.STMT.MON.RPT
*--------------------------------------------------------------------------------------------------------
*Description  : E.BUILD.STMT.MON is the BUILD routine
*               This routine is used to get category from STMT.GEN.CONDITION
*               for monthly for enquiry REDO.APAP.ACCT.STMT.TP
*In Parameter : N/A
*Out Parameter : N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                              Reference               Description
* -----------    ------------------------          ---------------        ----------------
* 18 MAR 2011      A.SABARIKUMAR                   ODR-2010-08-0181        Initial Creation
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion  - VM to @VM , FM to @FM and SM to @SM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 20-12-2023       Narmadha V              Manual R22 Conversion   ID variable used instead of Hardcoding,ID variable initialised
*---------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.GEN.CONDITION
    $INSERT I_F.STMT.ENTRY

    FN.STMT.GEN.CONDITION = 'F.STMT.GEN.CONDITION'
    F.STMT.GEN.CONDITION = ''
    CALL OPF(FN.STMT.GEN.CONDITION,F.STMT.GEN.CONDITION)
    MY.CAT.LIST = ''
    Y.ID = "MONTHLY" ;*Manual R22 Conversion
*CALL F.READ(FN.STMT.GEN.CONDITION,'MONTHLY',R.SGC.REC,F.STMT.GEN.CONDITION,Y.ERR)
    CALL F.READ(FN.STMT.GEN.CONDITION,Y.ID,R.SGC.REC,F.STMT.GEN.CONDITION,Y.ERR) ;*Manual R22 Conversion - ID variable used instead of Hardcoding
*    IF ENQ.SELECTION<1,1> EQ 'REDO.APAP.ACCT.STMT.TP.RPT' THEN
    Y.LAST.DAY = TODAY
    Y.YEAR.MONTH = TODAY[1,6]
    Y.FIRST.DAY = Y.YEAR.MONTH:'01'
    ENQUIRY.1.DATA<2,1> = 'PROCESSING.DATE'
    ENQUIRY.1.DATA<3,1> = 'RG'
    ENQUIRY.1.DATA<4,1> = Y.FIRST.DAY:' ':Y.LAST.DAY
*    END
    Y.ACCT.CAT = R.SGC.REC<ST.GEN.ITEM>
    Y.CAT.VALUE = R.SGC.REC<ST.GEN.VALUE>
    Y.ACCT.CAT = CHANGE(Y.ACCT.CAT,@SM,@VM)
    Y.CAT.VALUE = CHANGE(Y.CAT.VALUE,@SM,@VM)
    Y.ACCT.CAT = CHANGE(Y.ACCT.CAT,@VM,@FM)
    Y.CAT.VALUE = CHANGE(Y.CAT.VALUE,@VM,@FM)
    Y.CATEG.LIST = ''
    DCT= DCOUNT(Y.ACCT.CAT,@FM) ; *Tus Start
*FOR CAT.CT = 1 TO DCOUNT(Y.ACCT.CAT,FM)
    FOR CAT.CT = 1 TO DCT ;*Tus End
        IF Y.ACCT.CAT<CAT.CT> EQ "ACCOUNT>CATEGORY" THEN
            Y.CATEG.LIST<-1> = Y.CAT.VALUE<CAT.CT>
        END
    NEXT CAT.CT
    Y.CATEG.LIST = CHANGE(Y.CATEG.LIST,@FM,' ')
    ENQUIRY.1.DATA<2,-1> = 'PRODUCT.CATEGORY'
    ENQUIRY.1.DATA<3,-1> = 'EQ'
    ENQUIRY.1.DATA<4,-1> = Y.CATEG.LIST
RETURN
*---------------------------------------------------------------------------------------------------------
END
