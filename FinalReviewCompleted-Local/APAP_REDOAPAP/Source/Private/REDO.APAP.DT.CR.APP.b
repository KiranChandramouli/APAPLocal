* @ValidationCode : MjotMzIwODc2NTE6Q3AxMjUyOjE2ODA2NzIzMjk0MTc6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:55:29
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.DT.CR.APP(CR.APPROVER)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.CR.APP
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
*Description:  REDO.APAP.DT.TR.APP is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*             the routine checks if an OVERRIDE is generated, if generated then checks from the file
*             REDO.APAP.SIGNATORY.LIST if the INPUTTER is TRESURY and return the value accordingly
* In parameter  : None
* out parameter : CR.APPROVER
*Modification
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
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
        CR.APPROVER = 'N/A'
    END
    ELSE
        GOSUB GET.CR.APPROVER
    END
RETURN

GET.CR.APPROVER:
*Getting the Approval details
    VAR.INPUTTER = R.NEW(FX.INPUTTER)
    REDO.APAP.SIGNATORY.LIST.ID = FIELD(VAR.INPUTTER,'_',2)
    CALL F.READ(FN.REDO.APAP.SIGNATORY.LIST,REDO.APAP.SIGNATORY.LIST.ID,R.REDO.APAP.SIGNATORY.LIST,F.REDO.APAP.SIGNATORY.LIST,ERR.SIGN.LIST)
    IF NOT(R.REDO.APAP.SIGNATORY.LIST) THEN
        CR.APPROVER = 'N/A'
    END
    IF R.REDO.APAP.SIGNATORY.LIST<SIG.LIST.DEPARTMENT> EQ 'CREDIT' THEN
        CR.APPROVER = REDO.APAP.SIGNATORY.LIST.ID
    END
    ELSE
        CR.APPROVER = 'N/A'
    END
RETURN

END
