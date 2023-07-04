* @ValidationCode : MjotNDI4MzkzMzE5OkNwMTI1MjoxNjgwNzczNjY4MjIyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:04:28
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
SUBROUTINE REDO.DD.FT.OMSG(Y.OUT.MESSAGE)
***********************************************************
*-----------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.DD.FT.OMSG
*------------------------------------------------------------------------------


* DESCRIPTION : Out Msg Routine responsible for analyzing the result of processing of a OFS message,
*-----------------------------------------------------------------------------

*    LINKED WITH :
*    IN PARAMETER:
*    OUT PARAMETER: Y.OUT.MESSAGE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*31.08.2010      JEEVA T                ODR-2009-12-0290   INITIAL CREATION

* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.W.DIRECT.DEBIT

    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    FN.REDO.W.DIRECT.DEBIT = 'F.REDO.W.DIRECT.DEBIT'
    F.REDO.W.DIRECT.DEBIT = ''
    CALL OPF(FN.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT)
    Y.ERROR = ''
    Y.PART.1 = FIELD (Y.OUT.MESSAGE,',',1)
    Y.FT.ID = FIELD(Y.PART.1,'/',1)
    Y.ERROR =  FIELD(Y.PART.1,'/',3)
    Y.ID = 'FT'
    IF Y.ERROR NE '1' THEN
        CALL F.READ(FN.REDO.W.DIRECT.DEBIT,Y.ID,R.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT,Y.ERR)
        R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.FT.ID,-1> = Y.FT.ID
        CALL F.WRITE(FN.REDO.W.DIRECT.DEBIT,Y.ID,R.REDO.W.DIRECT.DEBIT)
    END
RETURN
END
