* @ValidationCode : MjotMTcxOTc4NTMzNTpDcDEyNTI6MTY4NDgzNjA0MjQ5MjpJVFNTOi0xOi0xOjc2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 76
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.INP.UPDATE.TR.APAP
*---------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : A C Rajkumar
* Program Name : REDO.APAP.INP.UPDATE.TR.APAP
* ODR NUMBER : ODR-2010-07-0074
*----------------------------------------------------------------------------------
* Description : This routine is a input routine used to update the Trader apap
* local refernce field in the FOREX,REDO.APAP.SPOTDEAL &
* FOREX,REDO.APAP.FORWARDDEAL versions accordingly
* In parameter : None
* out parameter : None
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*
*****
INIT:
*****
*
    FN.FOREX = 'F.FOREX'
    F.FOREX = ''
    CALL OPF(FN.FOREX, F.FOREX)
*
    Y.LRF.APPL = "FOREX"
    Y.LRF.FIELDS = 'L.FX.TR.APAP'
    FIELD.POS = ''
*
    CALL GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)
*
    Y.FX.TR.APAP = FIELD.POS<1,1>
RETURN
*
********
PROCESS:
********
*
    IF R.NEW(FX.DEAL.TYPE) NE 'SP' AND R.NEW(FX.DEAL.TYPE) NE 'FW' THEN
        RETURN
    END
*
    IF R.NEW(FX.CURR.NO) LT '1' THEN
        Y.FX.TRADER = OPERATOR
        R.NEW(FX.LOCAL.REF)<1,Y.FX.TR.APAP> = Y.FX.TRADER
    END
RETURN
*
END
*
