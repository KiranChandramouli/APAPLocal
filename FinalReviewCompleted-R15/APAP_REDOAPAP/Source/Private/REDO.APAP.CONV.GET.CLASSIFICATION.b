* @ValidationCode : MjotMTIyMzMzMDE4MjpDcDEyNTI6MTY4NDgzNjAzNjAwNTpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CONV.GET.CLASSIFICATION
*************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: PRADEEP P
* PROGRAM NAME: REDO.APAP.CONV.GET.CLASSIFICATION
* ODR NO      : ODR-2010-03-0088
*----------------------------------------------------------------------
* DESCRIPTION:   This is a conversion routine attached to the Enquiry
*                REDO.APAP.ENQ.REJ.DEBT.DET/REP which display the selection fields
*                based on Values inputted by the USER
* IN PARAMETER : O.DATA
* OUT PARAMETER: 0.DATA
* LINKED WITH  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE        WHO           REFERENCE         DESCRIPTION
* 16.11.2010  PRADEEP P    ODR-2010-03-0088  INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER

    GOSUB PROCESS
RETURN
*
PROCESS:
*-------
    Y.FINAL = ''

    LOCATE 'DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        Y.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>
        Y.FINAL = "FECHA - ":Y.DATE
    END

    LOCATE 'ACCOUNT.EXECUTIVE' IN D.FIELDS<1> SETTING Y.ACT.POS THEN
        Y.ACT.EXE = D.RANGE.AND.VALUE<Y.ACT.POS>
        IF Y.FINAL THEN
            Y.FINAL := ",":"OFICIAL DE LA CUENTA - ":Y.ACT.EXE
        END ELSE
            Y.FINAL = "OFICIAL DE LA CUENTA - ":Y.ACT.EXE
        END
    END

    O.DATA = Y.FINAL

RETURN
END
