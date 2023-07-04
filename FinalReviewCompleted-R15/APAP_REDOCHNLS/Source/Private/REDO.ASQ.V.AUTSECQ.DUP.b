* @ValidationCode : MjoxODEwNDExODA0OkNwMTI1MjoxNjg0ODU0MDUxNDI2OklUU1M6LTE6LTE6LTE0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:30:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -14
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOCHNLS
SUBROUTINE REDO.ASQ.V.AUTSECQ.DUP
**
* Subroutine Type : VERSION
* Attached to     : REDO.PREGUNTAS,NUEVO
* Attached as     : Field PREGUNTA as VALIDATION.RTN
* Primary Purpose : Validate if question is duplicated.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 31/01/13 - First Version
*            ODR Reference: ODR-2010-06-0075
*            Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.PREGUNTAS

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    FN.REDO.PREGUNTAS = 'F.REDO.PREGUNTAS'

RETURN

*-------
PROCESS:
*-------

    Y.QUESTION = R.NEW(RD.PS.PREGUNTA)

    SEL.CMD = 'SELECT ':FN.REDO.PREGUNTAS:' WITH PREGUNTA LIKE "':Y.QUESTION:'"'

    SEL.CMD.ERR = ''
    CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,'',ID.CNT,SEL.CMD.ERR)

    IF ID.CNT GE 1 THEN
        AF = RD.PS.PREGUNTA
        ETEXT = 'EB-REDO.ASQ.V.AUTSECQ.DUP'
        CALL STORE.END.ERROR
    END

RETURN

END
