* @ValidationCode : MjotMTE2NTgyMjg3MDpDcDEyNTI6MTY4MjQyMTYyMDE5MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:50:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         VM TO @VM, SM TO @SM,++ TO +=
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.LY.GET.INAUR2(R.DATA)
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.LY.POINTS

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*----------
OPEN.FILES:
*----------

    FN.REDO.LY.POINTS.NAU = 'F.REDO.LY.POINTS$NAU'
    F.REDO.LY.POINTS.NAU = ''
    CALL OPF(FN.REDO.LY.POINTS.NAU,F.REDO.LY.POINTS.NAU)

RETURN

*-------
PROCESS:
*-------

    Y.REC = ''
    Y.CUS.POS = ''
    LOCATE "CUSTOMER.ID" IN D.FIELDS<1> SETTING Y.CUS.POS THEN
        Y.REC = D.RANGE.AND.VALUE<Y.CUS.POS>
    END

    IF Y.REC EQ '' THEN
        GOSUB SEL.CUSTOMERS
    END ELSE
        GOSUB GET.CUSTOMER
    END

RETURN

*-------------
SEL.CUSTOMERS:
*-------------

    SEL.CMD = ''; Y.ERR = ''; SEL.LIST = ''
    SEL.CMD = 'SSELECT ':FN.REDO.LY.POINTS.NAU
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECORDS,Y.ERR)

    IF SEL.LIST THEN
        Y.CNT.REC = 1
        LOOP
        WHILE Y.CNT.REC LE NO.OF.RECORDS
            Y.REC = SEL.LIST<Y.CNT.REC>
            GOSUB GET.CUSTOMER
            Y.CNT.REC += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END

RETURN

*------------
GET.CUSTOMER:
*------------

    R.REDO.LY.POINTS.NAU = '' POINTS.ERR = ''
    CALL F.READ(FN.REDO.LY.POINTS.NAU,Y.REC,R.REDO.LY.POINTS.NAU,F.REDO.LY.POINTS.NAU,POINTS.ERR)
    IF R.REDO.LY.POINTS.NAU THEN
        Y.STATUS.SET = R.REDO.LY.POINTS.NAU<REDO.PT.STATUS>
        Y.MAN.USER.SET = R.REDO.LY.POINTS.NAU<REDO.PT.MAN.USER>
        CHANGE @VM TO @SM IN Y.STATUS.SET
        CHANGE @VM TO @SM IN Y.MAN.USER.SET
        Y.TOT.MAN.USER.SET = DCOUNT(Y.MAN.USER.SET,@SM)
        Y.CNT.MAN.USER = 1
        LOOP
        WHILE Y.CNT.MAN.USER LE Y.TOT.MAN.USER.SET
            Y.MAN.USER = FIELD(Y.MAN.USER.SET,@SM,Y.CNT.MAN.USER)
            Y.STATUS = FIELD(Y.STATUS.SET,@SM,Y.CNT.MAN.USER)
            IF FIELD(Y.MAN.USER,'-',2) EQ 'GEN' AND Y.STATUS EQ 'No.Liberada' THEN
                R.DATA<-1> = Y.REC
                Y.CNT.MAN.USER = Y.TOT.MAN.USER.SET
            END
            Y.CNT.MAN.USER += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
    END

RETURN

END
