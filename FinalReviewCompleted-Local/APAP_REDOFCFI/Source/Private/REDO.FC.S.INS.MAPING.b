* @ValidationCode : MjoxMTI5MzQ0MjAzOkNwMTI1MjoxNjgwNzgzNjY4MjIwOklUU1M6LTE6LTE6Mzk0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:51:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 394
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.INS.MAPING(P.FIELD.NAME, FIELD.NO)
*------------------------------------------------------------------------------------------------------------------

* Developer    : MGUDINO
* Date         : 2011-06-13
* Description  : This routine do de mapping between RCA and INS
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :

* Out :
*      P.MESSAGE                  Message to send by pharent call.
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0              2011-06-13    Marcelo Gudi First Version
* 1.0              2011-06-30    Marcelo Gudi
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_EB.TRANS.COMMON
    $INSERT I_F.LIMIT
    $INSERT I_F.COLLATERAL.RIGHT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.OFS.SOURCE
*
    $INSERT I_RAPID.APP.DEV.COMMON
*
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY
    $INSERT I_F.REDO.FC.POL.TYPE.CLASS
*
** Validar el campo field

    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
*** <region name= PROCESS>
PROCESS:
*
*------------------------------------------------------------------------------------------------------------------

    APP.NAME = 'REDO.CREATE.ARRANGEMENT'

    BEGIN CASE

        CASE P.FIELD.NAME EQ 'INS.DET.INS.POLICY.TYPE'
            P.FIELD.DAME = 'REDO.FC.INS.POLICY.TYPE'

        CASE P.FIELD.NAME EQ 'INS.DET.CLASS.POLICY'
            P.FIELD.DAME = 'REDO.FC.CLASS.POLICY'

        CASE P.FIELD.NAME EQ 'INS.DET.POLICY.NUMBER'
            P.FIELD.DAME = 'REDO.FC.POLICY.NUMBER'

        CASE P.FIELD.NAME EQ 'INS.DET.SEN.POLICY.NUMBER'
            P.FIELD.DAME = ' REDO.FC.SEN.POLICY.NUMBER'

        CASE P.FIELD.NAME EQ 'INS.DET.CUSTOMER'
            P.FIELD.DAME = 'REDO.FC.CUSTOMER.POL'

        CASE P.FIELD.NAME EQ 'INS.DET.CURRENCY'
            P.FIELD.DAME = 'REDO.FC.CURRENCY'

        CASE P.FIELD.NAME EQ 'INS.DET.MANAGEMENT.TYPE'
            P.FIELD.DAME = 'REDO.FC.INS.MANAGEM.TYPE'

        CASE P.FIELD.NAME EQ 'INS.DET.INS.COMPANY'
            P.FIELD.DAME = 'REDO.FC.INS.COMPANY'

        CASE P.FIELD.NAME EQ 'INS.DET.INS.AMOUNT'
            P.FIELD.DAME = 'REDO.FC.INS.AMOUNT'

        CASE P.FIELD.NAME EQ 'INS.DET.MON.POL.AMT'
            P.FIELD.DAME = 'REDO.FC.INS.MON.POL.AMT'

        CASE P.FIELD.NAME EQ 'INS.DET.MON.POL.AMT.DATE'
            P.FIELD.DAME = 'REDO.FC.DATE.AMT.SEC'

        CASE P.FIELD.NAME EQ 'INS.DET.EXTRA.AMT'
            P.FIELD.DAME = 'REDO.FC.INS.EXTRA.AMT'

        CASE P.FIELD.NAME EQ 'INS.DET.MON.TOT.PRE.AMT'
            P.FIELD.DAME = 'REDO.FC.INS.TOT.PREM.AMT'

        CASE P.FIELD.NAME EQ 'INS.DET.TOTAL.PRE.AMT'
            P.FIELD.DAME = 'REDO.FC.INS.TOTAL.PREM.AMT'

        CASE P.FIELD.NAME EQ 'INS.DET.INS.START.DATE'
            P.FIELD.DAME = 'REDO.FC.INS.DATE.BEG.CHARG'

        CASE P.FIELD.NAME EQ 'INS.DET.INS.END.DATE'
            P.FIELD.DAME = 'REDO.FC.INS.DATE.END.CHARG'

        CASE P.FIELD.NAME EQ 'INS.DET.POLICY.ORG.DATE'
            P.FIELD.DAME = 'REDO.FC.INS.POLI.ORG.DATE'

        CASE P.FIELD.NAME EQ 'INS.DET.POL.START.DATE'
            P.FIELD.DAME = 'REDO.FC.INS.POL.START.DATE'

        CASE P.FIELD.NAME EQ 'INS.DET.POL.EXP.DATE'
            P.FIELD.DAME = 'REDO.FC.INS.POL.EXP.DATE'

        CASE P.FIELD.NAME EQ 'INS.DET.REMARKS'
            P.FIELD.DAME = 'REDO.FC.INS.REMARKS'

    END CASE
    FIELD.NO = P.FIELD.DAME

    CALL EB.GET.APPL.FIELD(APP.NAME,FIELD.NO,'',Y.APP.ERR)

    CRT P.FIELD.DAME:" NO ":FIELD.NO
    CRT Y.APP.ERR

RETURN
*** </region>
*------------------------------------------------------------------------------------------------------------------
END
