* @ValidationCode : MjoxODg4OTEwMzUxOkNwMTI1MjoxNjg0ODM2MDM3NjIyOklUU1M6LTE6LTE6MTg0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 184
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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




SUBROUTINE REDO.APAP.DT.TR.APP(TR.APPROVER)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.TR.APP
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
*Description:  REDO.APAP.DT.TR.APP is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*             the routine checks if an OVERRIDE is generated, if generated then checks from the file
*             REDO.APAP.SIGNATORY.LIST if the INPUTTER is TRESURY and return the value accordingly
* In parameter  : None
* out parameter : TR.APPROVER
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.REDO.APAP.SIGNATORY.LIST

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN

OPEN.PARA:

    FN.REDO.APAP.SIGNATORY.LIST = 'F.REDO.APAP.SIGNATORY.LIST'
    F.REDO.APAP.SIGNATORY.LIST = ''
    CALL OPF(FN.REDO.APAP.SIGNATORY.LIST,F.REDO.APAP.SIGNATORY.LIST)

PROCESS.PARA:
    IF NOT(R.NEW(FX.OVERRIDE)) THEN
        TR.APPROVER = 'N/A'
    END
    ELSE
        GOSUB GET.TR.APPROVER
    END
RETURN

GET.TR.APPROVER:
*Getting the Approval details
    VAR.INPUTTER = R.NEW(FX.INPUTTER)
    REDO.APAP.SIGNATORY.LIST.ID = FIELD(VAR.INPUTTER,'_',2)
    CALL F.READ(FN.REDO.APAP.SIGNATORY.LIST,REDO.APAP.SIGNATORY.LIST.ID,R.REDO.APAP.SIGNATORY.LIST,F.REDO.APAP.SIGNATORY.LIST,ERR.SIGN.LIST)
    IF NOT(R.REDO.APAP.SIGNATORY.LIST) THEN
        TR.APPROVER = 'N/A'
    END
    IF R.REDO.APAP.SIGNATORY.LIST<SIG.LIST.DEPARTMENT> EQ 'TREASURY' THEN
        TR.APPROVER = REDO.APAP.SIGNATORY.LIST.ID
    END
    ELSE
        TR.APPROVER = 'N/A'
    END
RETURN

END
