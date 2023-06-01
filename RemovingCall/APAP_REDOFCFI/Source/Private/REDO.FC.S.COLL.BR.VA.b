* @ValidationCode : Mjo4NjE5ODg0ODQ6VVRGLTg6MTY4MzYxNjA4ODA5NDpJVFNTOi0xOi0xOi0yOToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 May 2023 12:38:08
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
SUBROUTINE REDO.FC.S.COLL.BR.VA
*----------------------------------------------------------------------------------------------------
* Subroutine Type : ROUTINE
* Attached to     : REDO.FC.S.COLL.BR
* Attached as     : CALLED FROM REDO.FC.S.COLL.BR
* Primary Purpose : GET IN THE VALUES OF THE COLLATERAL
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
* Development by  : Meza William - TAM Latin America
* Date            : Junio 24 2011

* Modified by     : Jorge Valarezo - TAM Latin America
* Date            : 11.05.2012
* Notes           : Rebuild it's a dependency of PAC00169926
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*25-APR-2023         Narmadha V                        MANUAL R22 CODE CONVERSION        call routine format modified
*-----------------------------------------------------------------------------------
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


    IF OFS$HOT.FIELD MATCHES 'SEC.NO.STATE.BR...' THEN
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

        Y.COUNT = DCOUNT(R.NEW(REDO.FC.TYPE.OF.SEC.BR),@VM)
        GOSUB CLR.COLL.RIGHT.FLDS
        FOR Y.I = 1 TO Y.COUNT
            Y.SEC.NO = R.NEW(REDO.FC.SEC.NO.STATE.BR)<1,Y.I>
            IF Y.SEC.NO THEN
                GOSUB NUMERO.GARANTIA
            END
        NEXT Y.I

    END

RETURN


* =========
NUMERO.GARANTIA:
* =========

    Y.SEC.TYPE = R.NEW(REDO.FC.TYPE.OF.SEC.BR)<1,Y.I>
    CALL APAP.REDOFCFI.redoFcSMapping(Y.SEC.TYPE, Y.SEC.NO, Y.I);*MANUAL R22 CODE CONVERSION
    

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
