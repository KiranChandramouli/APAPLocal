* @ValidationCode : MjotOTM2ODYwNDMzOkNwMTI1MjoxNjgxOTA1Njc5ODgxOklUU1M6LTE6LTE6OTA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 90
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.GET.PAY.FORM(VAR.PAY.FORM)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.GET.PAY.FORM
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get PAYMENT MODE
* ----------------------------------------------------------------------------------
* Modification History :
*****************************************************************
*DATE                    MODIFIED BY                                   CONTENT MODIFIED
*------                        ---------------                                -------------------------
*2021013                Soundarya                        PACS00930966-Client mentioned that while authorizing the AZ.ACCOUNT record using ENQ REDO.FD.PRECLOSE.AUTH.NAU, system is always displaying the CREDITO A CUENTA for FORMA DE PAGO in deal slip
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 VM TO @VM, FM TO @FM
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.AZ.FUND.PARAM

    GOSUB PROCESS

RETURN

*********
PROCESS:
**********

    FN.REDO.AZ.FUND.PARM = 'F.REDO.AZ.FUND.PARAM'
    F.REDO.AZ.FUND.PARAM = ''
    CALL OPF(FN.REDO.AZ.FUND.PARM,F.REDO.AZ.FUND.PARAM)

    VAR.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.AZ.FUND.PARM,VAR.ID,R.FUND.PARAM,FUND.ERR)

    BEGIN CASE

        CASE APPLICATION EQ 'ACCOUNT.CLOSURE'

            IF PGM.VERSION EQ ',REDO.EN.LINEA' THEN
                VAR.PAY.FORM = 'CREDITO A CUENTA'
            END ELSE
                VAR.PAY.FORM = 'EFECTIVO'
            END

        CASE APPLICATION EQ 'AZ.ACCOUNT'

            VAR.CURRENCY =  R.NEW(AZ.CURRENCY)

            CCY.PARAM = R.FUND.PARAM<REDO.FUND.CURRENCY>
            CHANGE @VM TO @FM IN CCY.PARAM
            LOCATE VAR.CURRENCY IN CCY.PARAM SETTING CCY.POS THEN
                VAR.ACCT.NUM = R.FUND.PARAM<REDO.FUND.ACCT.NUMBER,CCY.POS>
                Y.NOMINATE.ACCOUNT = R.NEW(AZ.NOMINATED.ACCOUNT)

            END
*PACS00930966 - Start
            IF VAR.ACCT.NUM AND Y.NOMINATE.ACCOUNT AND (Y.NOMINATE.ACCOUNT EQ VAR.ACCT.NUM) THEN
                VAR.PAY.FORM = 'EFECTIVO'
            END ELSE
                VAR.PAY.FORM = 'CREDITO A CUENTA'
            END
*PACS00930966 - End

    END CASE

RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
