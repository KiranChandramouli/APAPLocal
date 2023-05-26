* @ValidationCode : MjoxNzkzMjE3OTk3OkNwMTI1MjoxNjg0ODQyMTQ5NDM1OklUU1M6LTE6LTE6NzY6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 76
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VID.MONITOR.RAD

*-----------------------------------------------------------------------------
* Primary Purpose: Control of ID in definition of mapping for MONITOR
*                  Interface
*-----------------------------------------------------------------------------
* Modification History:
*
* 06/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN

*-----------------------------------------------------------------------------------
PROCESS:

*DEBUG

    IF COMI  THEN
*Format validation
        Y.COUNT = DCOUNT(COMI,'/')
        IF Y.COUNT NE 3 THEN
            E = 'FORMATO INVALIDO'
            RETURN
        END

*Application Validation
        Y.APPLICATION = FIELD(COMI,'/',1)
        CALL CACHE.READ(FN.SS,Y.APPLICATION,R.SS,ERR.SS)
        IF ERR.SS THEN
            E = 'APLICACION INVALIDA'
            RETURN
        END

* Table Monitor Validation
        Y.MNEM.MON.TABLE = FIELD(COMI,'/',2)
        SEL.CMD = 'SELECT ' : FN.REDO.MON.TABLE : ' WITH MNEMONIC EQ ' : Y.MNEM.MON.TABLE
        CALL EB.READLIST(SEL.CMD,Y.LIST,'',NO.OF.REG,RET.CODE)
        IF NO.OF.REG NE 1 THEN
            E = 'MNEMONICO TABLA MONITOR INCORRECTO'
            RETURN
        END

    END

RETURN

*-----------------------------------------------------------------------------------
INITIALISE:
    FN.SS = 'F.STANDARD.SELECTION' ; F.SS = ''

    FN.REDO.MON.TABLE = 'F.REDO.MONITOR.TABLE'
    F.REDO.MON.TABLE = ''
RETURN
*-----------------------------------------------------------------------------------

*-----------------------------------------------------------------------------------
OPEN.FILES:
    CALL OPF(FN.REDO.MON.TABLE, F.REDO.MON.TABLE)
RETURN
*-----------------------------------------------------------------------------------


END
