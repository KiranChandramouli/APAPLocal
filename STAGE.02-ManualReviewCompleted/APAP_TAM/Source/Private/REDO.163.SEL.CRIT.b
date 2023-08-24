* @ValidationCode : MjoxMzQzMTk1MTE3OkNwMTI1MjoxNjgwNjE3NTA0NjU5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 19:41:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.163.SEL.CRIT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.SEL.CRITERIA
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.APAP.ENQ.INV.GEN.RPT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    19 04 2012           Ganesh R          ODR-2010-03-0103           Initial Creation
*    04.04.2023          Conversion Tool         R22                   Auto Conversion     - No changes
*    04.04.2023          Shanmugapriya M         R22                   Manual Conversion   - No changes
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.COLLATERAL.CODE
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    FN.COL.CODE = 'F.COLLATERAL.CODE'
    F.COL.CODE = ''
    CALL OPF(FN.COL.CODE,F.COL.CODE)

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.CRITERIA = ''

    Y.DATE     = FIELD(O.DATA,'*',1)
    Y.MVMT     = FIELD(O.DATA,'*',2)
    Y.REASON   = FIELD(O.DATA,'*',3)
    Y.LOC.STAT = FIELD(O.DATA,'*',4)
    Y.CODE     = FIELD(O.DATA,'*',5)
    Y.RESP     = FIELD(O.DATA,'*',6)
    Y.LBL1     = FIELD(O.DATA,'*',7)
    Y.LBL2     = FIELD(O.DATA,'*',8)
    Y.LBL3     = FIELD(O.DATA,'*',9)
    Y.LBL4     = FIELD(O.DATA,'*',10)
    Y.LBL5     = FIELD(O.DATA,'*',11)
    Y.LBL6     = FIELD(O.DATA,'*',12)

    IF Y.DATE THEN
        Y.CRITERIA =   Y.LBL1:' - ':Y.DATE:' '
    END

    IF Y.MVMT THEN
        Y.CRITERIA :=  Y.LBL2:' - ':Y.MVMT:' '
    END

    IF Y.REASON THEN
        Y.CRITERIA :=  Y.LBL3:' - ':Y.REASON:' '
    END

    IF Y.LOC.STAT THEN
        Y.CRITERIA :=  Y.LBL4:' - ':Y.LOC.STAT:' '
    END
    IF Y.CODE THEN
        CALL F.READ(FN.COL.CODE,Y.CODE,R.COL.CODE,F.COL.CODE,CO.DERR)
        Y.DESC = R.COL.CODE<COLL.CODE.DESCRIPTION,2>
        IF Y.DESC EQ '' THEN
            Y.DESC = R.COL.CODE<COLL.CODE.DESCRIPTION,1>
        END
        Y.CRITERIA :=  Y.LBL5:' - ':Y.CODE:' ':Y.DESC
    END
    IF Y.RESP THEN
        Y.CRITERIA :=  Y.LBL6:' - ':Y.RESP
    END
    IF Y.CRITERIA EQ '' THEN
        Y.CRITERIA = 'All'
    END
    O.DATA = Y.CRITERIA

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
