* @ValidationCode : MjotMTMzMzg4MTg5ODpDcDEyNTI6MTY4MTI5NzE4NTM4ODphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 16:29:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.E.CONV.SEL.CRIT.PRESTN1
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : T.Jeeva, Temenos Application Management
*Program   Name    : REDO.APAP.E.CONV.SEL.CRIT.PRESTN1
*ODR Reference     : ODR-2010-03-0183
*--------------------------------------------------------------------------------------------------------
*Description  :REDO.APAP.E.CONV.SEL.CRIT.PRESTN1 is a conversion routine attached to the enquiries
*              REDO.APAP.ENQ.PAYMENT.DYNAMIC.RPT and REDO.APAP.ER.PAYMENT.DYNAMIC.RPT, the routine fetches
*              the value from ENQ.SELECTION formats them according to the selection criteria and returns
*              the value back to O.DATA
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

*--------------------------------------------------------------------------------------------------------
MAIN.PARA:
*--------------------------------------------------------------------------------------------------------

    GOSUB PROCESS.PARA
RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------

    Y.CRITERIA = ''
    LOCATE 'DOM.DATE' IN ENQ.SELECTION<2,1> SETTING Y.DOM.POS THEN
        Y.CRITERIA := ' Domiciliation Date es igual a ':ENQ.SELECTION<4,Y.DOM.POS>:' '
    END

    LOCATE 'CO.CODE' IN ENQ.SELECTION<2,1> SETTING Y.AGENCY.POS THEN
        Y.CRITERIA := ' Agencia es igual a ':ENQ.SELECTION<4,Y.AGENCY.POS>:''
    END

    LOCATE 'REGION' IN ENQ.SELECTION<2,1> SETTING Y.REGION.POS THEN
        Y.CRITERIA := ' Regisn es igual a ':ENQ.SELECTION<4,Y.REGION.POS>:''
    END

    LOCATE 'PRODUCT' IN ENQ.SELECTION<2,1> SETTING Y.PROD.POS THEN
        Y.CRITERIA := ' Tipo de Producto es igual a ':ENQ.SELECTION<4,Y.PROD.POS>:''
    END

    LOCATE 'PRODUCT.GROUP' IN ENQ.SELECTION<2,1> SETTING Y.PORT.POS THEN
        Y.CRITERIA := ' Tipo de Cartera es igual a ':ENQ.SELECTION<4,Y.PORT.POS>:''
    END

    LOCATE 'LOAN.STATUS' IN ENQ.SELECTION<2,1> SETTING Y.LN.STAT.POS THEN
        Y.CRITERIA := ' Estatus del Pristamo es igual a ':ENQ.SELECTION<4,Y.LN.STAT.POS>:''
    END
    LOCATE 'AGING.STATUS' IN ENQ.SELECTION<2,1> SETTING Y.LN.STAT.POS THEN
        Y.CRITERIA := ' Estatus Por Morosidad igual a ':ENQ.SELECTION<4,Y.LN.STAT.POS>:''
    END
    LOCATE 'ARR.STATUS' IN ENQ.SELECTION<2,1> SETTING Y.LN.O.STAT.POS THEN
        Y.CRITERIA := ' Estado del Pristamo es igual a ':ENQ.SELECTION<4,Y.LN.O.STAT.POS>:''
    END

    LOCATE 'CAMP.TYPE' IN ENQ.SELECTION<2,1>  SETTING Y.CAMP.POS THEN
        Y.CRITERIA := ' Tipo de Campaqa es igual a ':ENQ.SELECTION<4,Y.CAMP.POS>:''
    END

    LOCATE 'AFF.COMP' IN ENQ.SELECTION<2,1> SETTING Y.AFF.POS THEN
        Y.CRITERIA := ' Compaqia afiliada es igual a ':ENQ.SELECTION<4,Y.AFF.POS>:''
    END

    LOCATE 'DUE.DATE' IN ENQ.SELECTION<2,1> SETTING Y.DUE.POS THEN
        Y.CRITERIA := ' Quota Due Date es igual a ':ENQ.SELECTION<4,Y.DUE.POS>:''
    END


    O.DATA =  Y.CRITERIA

RETURN

END
