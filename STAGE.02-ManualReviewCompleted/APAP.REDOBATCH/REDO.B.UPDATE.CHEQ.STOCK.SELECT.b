* @ValidationCode : Mjo2MDE1MjgwNTI6Q3AxMjUyOjE2ODE3MDcyNjg2NjE6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 10:24:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPDATE.CHEQ.STOCK.SELECT
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.UPDATE.CHEQ.STOCK.SELECT
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.UPDATE.CHEQ.STOCK on an yearly basis

* In parameter : None
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------
* DATE               WHO          REFERENCE         DESCRIPTION
* 22.03.2010  SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - ++ TO += 1
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
* ----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CERTIFIED.CHEQUE.STOCK
    $INSERT I_F.CERTIFIED.CHEQUE.STOCK.HIS
    $INSERT I_F.DATES
    $INSERT I_REDO.B.UPDATE.CHEQ.STOCK.COMMON
    SEL.CMD=''
    SEL.LIST=''
    NO.OF.REC=''
    ERR=''
    VAR1=1
    SEL.CMD="SELECT ":FN.CERTIFIED.CHEQUE.STOCK:" WITH STATUS EQ AVAILABLE"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)
    LOOP
    WHILE VAR1 LE NO.OF.REC
        SEL.LIST.ID=SEL.LIST<VAR1>
        Y.DATE.COMPARE=SEL.LIST.ID[2,2]
        Y.TODAY.DATE = R.DATES(EB.DAT.TODAY)
        Y.LEFT.TODAY.DATE = LEFT(Y.TODAY.DATE,4)
        Y.TODAY = RIGHT(Y.LEFT.TODAY.DATE,2)
        IF Y.DATE.COMPARE EQ Y.TODAY THEN
            ID.LIST<-1>=SEL.LIST.ID
        END
        VAR1 += 1
    REPEAT
    CALL BATCH.BUILD.LIST('',ID.LIST)
RETURN
END
