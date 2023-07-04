* @ValidationCode : MjoxMTU1ODkyNjYwOkNwMTI1MjoxNjgzNjE2MDg3ODA3OklUU1M6LTE6LTE6LTE4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 May 2023 12:38:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -18
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.FC.S.CALC.DT.VH
* ============================================================================
*
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose : VALIDATION TYPE.RATE.REV
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo (jvalarezoulloa@temenos.com) - TAM Latin America
* Date            : DEC 10 2012
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 04-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 04-APRIL-2023      Harsha                R22 Manual Conversion - VM to @VM and Y.NUM.COL to Y.POS 
*============================================================================

******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_System
    $INSERT I_GTS.COMMON
******************************************************************************

    GOSUB INITIALISE

RETURN

* =========
INITIALISE:
* =========

    CAMPO.ACTUAL = OFS$HOT.FIELD
    NOMBRE.CAMPO = "...VAL.DATE.VS..."

    IF CAMPO.ACTUAL MATCH NOMBRE.CAMPO THEN
        Y.FECHA.REV = COMI
        Y.POS = AV
        GOSUB PROCESS
    END
    ELSE

        Y.NUM.COL = DCOUNT(R.NEW (REDO.FC.VAL.DATE.VS),@VM)   ;*R22 Manual Conversion VM to @VM
        FOR Y.POS = 1 TO Y.NUM.COL
            Y.FECHA.REV = R.NEW (REDO.FC.VAL.DATE.VS)<1,Y.POS>
            GOSUB PROCESS
        NEXT Y.POS ;*R22 Manual Conversion Y.NUM.COL to Y.POS
    END





RETURN
*
* ======
PROCESS:
* ======
*
    IF  Y.FECHA.REV EQ '' THEN
        RETURN
    END

    Y.MONTH = R.NEW(REDO.FC.FREC.REV.VS)<1,Y.POS>
    IF LEN(Y.MONTH) EQ 1 THEN
        Y.MONTH = '0':Y.MONTH
    END


    Y.COMI = COMI
    Y.DAY  = SUBSTRINGS (Y.FECHA.REV,7,8)

    COMI = Y.FECHA.REV : "M":Y.MONTH:Y.DAY
    CALL CFQ
    Y.DATE = COMI[1,8]
    COMI = Y.COMI

    R.NEW (REDO.FC.MATUR.DATE.VS)<1,Y.POS>= Y.DATE

RETURN
END
