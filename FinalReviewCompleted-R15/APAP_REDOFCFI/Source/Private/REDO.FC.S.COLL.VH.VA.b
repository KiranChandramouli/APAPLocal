* @ValidationCode : MjotMjEwODI3NjQwMTpVVEYtODoxNjgzNjE2MDg5NzUzOklUU1M6LTE6LTE6LTI5OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 May 2023 12:38:09
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -29
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.COLL.VH.VA
*----------------------------------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : TEMPLATE REDO.CREATE.ARRANGEMENT
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres - TAM Latin America
* Date            : Jun 24, 2011
*
* Modified by     : Luis Pazmino - TAM Latin America
* Date            : Dec 07, 2011
* Notes           : Minor fixes - PQC Code Revision

* Modified by     : Jorge Valarezo - TAM Latin America
* Date            : 11.05.2012
* Notes           : Rebuild it's a dependency of PAC00169926
*  DATE             WHO                   REFERENCE
* 04-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM and FM to @FM
* 04-APRIL-2023      Harsha                R22 Manual Conversion - Added APAP.REDOFCFI to CALL
*------------------------------------------------------------------------
*-----------------------------------------------------------------------------------

************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_GTS.COMMON


    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

* ======
PROCESS:
* ======


    IF OFS$HOT.FIELD MATCHES 'SEC.NO.STATE.VS...' THEN
        Y.CAMPO.HOTVLD = OFS$HOT.FIELD
        CHANGE "." TO @FM IN Y.CAMPO.HOTVLD
        YPOSU = DCOUNT(Y.CAMPO.HOTVLD,@FM)
        Y.I = FIELD(Y.CAMPO.HOTVLD,@FM,YPOSU)
        Y.SEC.NO      = COMI
        IF COMI THEN
            GOSUB NUMERO.GARANTIA
        END
    END
    ELSE

        Y.COUNT = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.VS),@VM)
        GOSUB CLR.COLL.RIGHT.FLDS
        FOR Y.I = 1 TO Y.COUNT
            Y.SEC.NO = R.NEW(REDO.FC.SEC.NO.STATE.VS)<1,Y.I>
            IF Y.SEC.NO THEN
                GOSUB NUMERO.GARANTIA
            END
        NEXT Y.I

    END

RETURN


* =========
NUMERO.GARANTIA:
* =========

    Y.SEC.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.VS)<1,Y.I>
    APAP.REDOFCFI.redoFcSMapping(Y.SEC.TYPE, Y.SEC.NO, Y.I)  ;*R22 Manual Conversion - Added APAP.REDOFCFI

RETURN


* =========
INITIALISE:
* =========
    Y.CONT = ""
    Y.I = ""
RETURN
*------------------------------------------------------------------------------------------------------------------
CLR.COLL.RIGHT.FLDS:
*------------------------------------------------------------------------------------------------------------------
    R.NEW(REDO.FC.ID.COLLATERL.RIGHT)=''
    R.NEW(REDO.FC.COLL.RIGHT.CODE)=''
    R.NEW(REDO.FC.LIMIT.REFERENCE)=''
    R.NEW(REDO.FC.VALIDITY.DATE)=''
    R.NEW(REDO.FC.SEC.HOLD.IDENTIF)=''
RETURN

END
