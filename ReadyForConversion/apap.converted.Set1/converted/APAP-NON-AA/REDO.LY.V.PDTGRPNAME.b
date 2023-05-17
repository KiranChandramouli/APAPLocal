SUBROUTINE REDO.LY.V.PDTGRPNAME
**
* Subroutine Type : VERSION
* Attached to     : REDO.LY.PDT.TYPE,CREATE
* Attached as     : Field PRODUCT.NAME as VALIDATION.RTN
* Primary Purpose : Validate if name inputted has been used in
*                   another product group.
*-----------------------------------------------------------------------------
* MODIFICATIONS HISTORY
*
* 04/02/13 - First Version
*            ODR Reference: ODR-2011-06-0243
*            Project: NCD Asociacion Popular de Ahorros y Prestamos (APAP)
*            Roberto Mondragon - TAM Latin America
*            rmondragon@temenos.com
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PDT.TYPE

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    FN.REDO.LY.PDT.TYPE = 'F.REDO.LY.PDT.TYPE'
    F.REDO.LY.PDT.TYPE = ''
    CALL OPF(FN.REDO.LY.PDT.TYPE,F.REDO.LY.PDT.TYPE)

RETURN

*-------
PROCESS:
*-------

    Y.NAME.INP = COMI

    SEL.CMD = 'SELECT ':FN.REDO.LY.PDT.TYPE

    SEL.CMD.ERR = ''
    CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,'',ID.CNT,SEL.CMD.ERR)

    ID.CNT.LOOP = 1
    LOOP
    WHILE ID.CNT.LOOP LE ID.CNT
        ID.PDTGRP = FIELD(SEL.CMD.LIST,@FM,ID.CNT.LOOP)
        R.REDO.LY.PDT.TYPE = ''; PT.ERR = ''
        CALL F.READ(FN.REDO.LY.PDT.TYPE,ID.PDTGRP,R.REDO.LY.PDT.TYPE,F.REDO.LY.PDT.TYPE,PT.ERR)
        IF R.REDO.LY.PDT.TYPE THEN
            Y.PDTGRP.NAME = R.REDO.LY.PDT.TYPE<REDO.PDT.PRODUCT.NAME>
            IF Y.NAME.INP EQ Y.PDTGRP.NAME AND ID.PDTGRP NE ID.NEW THEN
                AF = REDO.PDT.PRODUCT.NAME
                ETEXT = 'EB-REDO.LY.V.PDTGRPNAME'
                CALL STORE.END.ERROR
                ID.CNT.LOOP = ID.CNT
            END
        END
        ID.CNT.LOOP += 1
    REPEAT

RETURN

END
