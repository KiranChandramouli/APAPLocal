* @ValidationCode : MjotMjEwNzI2Njc1MjpDcDEyNTI6MTY4MTgxMzExNzc5ODpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 15:48:37
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.SEL.CRITERIA
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
*    26 09 2010       Jeyachandran S          ODR-2010-03-0105           Initial Creation
*    24/03/2014       Vignesh Kumaar R        PACS00309831               IF NO SELECTION INFO IS PROVIDED THEN 'TODOS'
*********************************************************************************************************
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    Y.CRITERIA = ''

    Y.AGENCY  = FIELD(O.DATA,'*',1)
    Y.INVEST.TYPE = FIELD(O.DATA,'*',2)
    Y.CLIENT.TYPE = FIELD(O.DATA,'*',3)
    Y.CURRENCY = FIELD(O.DATA, '*', 4)
    Y.AMOUNT = FIELD(O.DATA, '*', 5)
    Y.PAY.METHOD = FIELD(O.DATA, '*', 6)


    IF Y.AGENCY THEN
*        SET.F = "Y"
        Y.CRITERIA = 'Agencia - ':Y.AGENCY:'; '
    END

    IF Y.INVEST.TYPE THEN
*        SET.I = "Y"
*        IF SET.F EQ "Y" THEN
*            Y.CRITERIA := ",":'Tipo de Inversion - ':Y.INVEST.TYPE
*        END ELSE
        Y.CRITERIA :=  ' Tipo de Inversion - ':Y.INVEST.TYPE:'; '
*        END
    END


    IF Y.CLIENT.TYPE THEN
*        IF SET.F EQ "Y" OR SET.I EQ "Y" THEN
*            Y.CRITERIA := ",":'Tipo de Cliente - ':Y.CLIENT.TYPE
*        END ELSE
        Y.CRITERIA := 'Tipo de Cliente - ':Y.CLIENT.TYPE:'; '
*        END
    END

    IF Y.CURRENCY THEN
        Y.CRITERIA := 'Moneda - ':Y.CURRENCY:';'
    END

    IF Y.AMOUNT THEN
        Y.CRITERIA  := 'Monto - ':FIELD(Y.AMOUNT, ' ', 1):' a ':FIELD(Y.AMOUNT, ' ', 2)
    END

    IF Y.PAY.METHOD THEN

        FN.EB.LOOKUP = 'F.EB.LOOKUP'
        F.EB.LOOKUP = ''
        CALL OPF(FN.EB.LOOKUP, F.EB.LOOKUP)

        Y.EBL.ID = 'L.TYPE.INT.PAY*':Y.PAY.METHOD
        CALL F.READ(FN.EB.LOOKUP, Y.EBL.ID, R.EBL, F.EB.LOOKUP, Y.READ.ERR)

        Y.PAY.METHOD = R.EBL<EB.LU.DESCRIPTION, LNGG>

        IF NOT(Y.PAY.METHOD) THEN
            Y.PAY.METHOD = R.EBL<EB.LU.DESCRIPTION, 1>
        END

        Y.CRITERIA := 'FORMA PAGO INTERESES - ':Y.PAY.METHOD
    END

* Fix for PACS00309831 [IF NO SELECTION INFO IS PROVIDED THEN 'TODOS']

    IF Y.CRITERIA EQ '' THEN
        Y.CRITERIA = 'TODOS'
    END

* End of Fix

    O.DATA = Y.CRITERIA

RETURN

END
