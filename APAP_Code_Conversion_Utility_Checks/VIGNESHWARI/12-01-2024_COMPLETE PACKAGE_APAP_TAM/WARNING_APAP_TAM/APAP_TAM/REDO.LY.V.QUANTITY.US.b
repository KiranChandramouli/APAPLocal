* @ValidationCode : MjoyODU4NjY2MDY6VVRGLTg6MTcwNDk1NDY2NjQ3NjpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Jan 2024 12:01:06
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.V.QUANTITY.US
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the quantity of points/amount to be used vs
*              available points/amount
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.QUANTITY.US
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*12.06.2012    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*10.07.2012    RMONDRAGON         ODR-2011-06-0243     SECOND VERSION
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION       	   FM TO @FM, VM TO @VM
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.POINTS.US
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_F.REDO.LY.MASTERPRGDR
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

*----
INIT:
*----

    FN.REDO.LY.POINTS.US = 'F.REDO.LY.POINTS.US'
    F.REDO.LY.POINTS.US = ''
    CALL OPF(FN.REDO.LY.POINTS.US,F.REDO.LY.POINTS.US)

    FN.REDO.LY.POINTS.TOT = 'F.REDO.LY.POINTS.TOT'
    F.REDO.LY.POINTS.TOT = ''
    CALL OPF(FN.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT)

    FN.REDO.LY.MASTERPRGDR = 'F.REDO.LY.MASTERPRGDR'
    F.REDO.LY.MASTERPRGDR = ''
    CALL OPF(FN.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR)

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

RETURN

*-------
PROCESS:
*-------

    Y.US.CUST = R.NEW(REDO.PT.US.CUSTOMER.NO)
    Y.US.PROGRAM = R.NEW(REDO.PT.US.PROGRAM)
    Y.US.TYPE = R.NEW(REDO.PT.US.TYPE.US)
    Y.US.QTYORVAL = R.NEW(REDO.PT.US.QTYORVAL)
    Y.US.STATUS = R.OLD(REDO.PT.US.STATUS.US)
    Y.QUANTITY = COMI

    IF Y.QUANTITY EQ '' THEN
        RETURN
    END

    Y.QUANTITY = FMT(Y.QUANTITY,0)

    IF Y.US.TYPE EQ 'Normal' THEN
        GOSUB CHECK.PROGRAM
*PACS00521794-S
*Y.ID.FOR.TOT = Y.US.CUST:Y.US.PROGRAM:'ALL':TODAY[1,4]
        Y.ID.FOR.TOT = Y.US.CUST:Y.US.PROGRAM
        SEL.CMD = "SELECT ": FN.REDO.LY.POINTS.TOT :" WITH @ID LIKE " : Y.ID.FOR.TOT :'...'
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.CNT,SEL.ERR)
*PACS00521794-E
    END ELSE
        Y.ID.FOR.TOT = Y.US.CUST:'ONLINEDEB'
    END

    GOSUB READ.REC.TOT

    IF Y.POINT.AV EQ '' OR Y.POINT.AV EQ 0 THEN
        IF Y.US.TYPE EQ 'Normal' THEN
            AF = REDO.PT.US.QTYORVAL.TO.US
            ETEXT = 'EB-REDO.LY.V.QUANTITY.US'
            CALL STORE.END.ERROR
            RETURN
        END ELSE
            AF = REDO.PT.US.QTYORVAL.TO.US
            ETEXT = 'EB-REDO.LY.V.QUANTITY.US2'
            CALL STORE.END.ERROR
            RETURN
        END
    END

    IF Y.US.STATUS NE '2' THEN
        IF Y.QUANTITY LT 1 OR Y.QUANTITY GT Y.POINT.AV THEN
            AF = REDO.PT.US.QTYORVAL.TO.US
            ETEXT = 'EB-REDO.LY.V.QUANTITY.US3':@FM:Y.POINT.AV
            CALL STORE.END.ERROR
            RETURN
        END
    END

    GOSUB READ.PROGRAM

    T(REDO.PT.US.QUANTITY)<3> = ''
    T(REDO.PT.US.QTY.VALUE)<3> = ''
    R.NEW(REDO.PT.US.QUANTITY) = Y.POINT
    R.NEW(REDO.PT.US.QTY.VALUE) = Y.POINT.VAL
    T(REDO.PT.US.QUANTITY)<3> = 'NOINPUT'
    T(REDO.PT.US.QTY.VALUE)<3> = 'NOINPUT'

RETURN

*-------------
CHECK.PROGRAM:
*-------------

    IF Y.US.PROGRAM EQ '' THEN
        COMI = ''
        AF = REDO.PT.US.PROGRAM
        ETEXT = 'EB-REDO.LY.V.QUANTITY.US4'
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

*------------
READ.REC.TOT:
*------------

    Y.POINT.AV = ''
    R.REDO.LY.POINTS.TOT = '' ; TOT.ERR = ''
*PACS00521794-S
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS
    WHILE Y.ID:POS
        FINDSTR "ALL" IN Y.ID SETTING POS1, POS2 THEN
*CALL F.READ(FN.REDO.LY.POINTS.TOT,Y.ID.FOR.TOT,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
            CALL F.READ(FN.REDO.LY.POINTS.TOT,Y.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR)
*PACS00521794-E
            IF R.REDO.LY.POINTS.TOT THEN
                IF Y.US.QTYORVAL EQ 'Puntos' THEN
                    Y.POINT.AV = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
                END ELSE
                    Y.POINT.AV = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>
                END
            END
        END
    REPEAT
RETURN

*------------
READ.PROGRAM:
*------------

    IF Y.US.PROGRAM EQ '' AND Y.US.TYPE EQ 'Por.TDebito' THEN
        GOSUB GET.MASTER.PRG
        T(REDO.PT.US.PROGRAM)<3> = ''
        R.NEW(REDO.PT.US.PROGRAM) = Y.US.PROGRAM
        T(REDO.PT.US.PROGRAM) = 'NOINPUT'
    END

    R.REDO.LY.PROGRAM = '' ; PRG.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.US.PROGRAM,R.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM,PRG.ERR)
    IF R.REDO.LY.PROGRAM THEN
        IF Y.US.QTYORVAL EQ 'Puntos' THEN
            Y.POINT = Y.QUANTITY
            Y.POINT.VAL = R.REDO.LY.PROGRAM<REDO.PROG.POINT.VALUE>
            Y.POINT.VAL = Y.QUANTITY * Y.POINT.VAL
            Y.POINT.VAL = FMT(Y.POINT.VAL,0)
            Y.POINT = FMT(Y.POINT,0)
        END ELSE
            Y.POINT.VAL = Y.QUANTITY
            Y.POINT = R.REDO.LY.PROGRAM<REDO.PROG.POINT.VALUE>
            Y.POINT = Y.QUANTITY / Y.POINT
            Y.POINT = FMT(Y.POINT,0)
            Y.POINT.VAL = FMT(Y.POINT.VAL,0)
        END
        Y.POINT.MIN = R.REDO.LY.PROGRAM<REDO.PROG.MIN.POINT.USED>
        Y.POINT.MAX = R.REDO.LY.PROGRAM<REDO.PROG.MAX.POINT.USED>
        GOSUB CHECK.LIM.USE
    END

RETURN

*--------------
GET.MASTER.PRG:
*--------------

    R.REDO.LY.MASTERPRGDR = '' ; MAS.ERR = ''

*  CALL F.READ(FN.REDO.LY.MASTERPRGDR,'SYSTEM',R.REDO.LY.MASTERPRGDR,F.REDO.LY.MASTERPRGDR,MAS.ERR) ;*Tus Start
*    CALL CACHE.READ(FN.REDO.LY.MASTERPRGDR,'SYSTEM',R.REDO.LY.MASTERPRGDR,MAS.ERR) ; * Tus End
    IDVAR.1 = 'SYSTEM' ;* R22 UTILITY AUTO CONVERSION
    CALL CACHE.READ(FN.REDO.LY.MASTERPRGDR,IDVAR.1,R.REDO.LY.MASTERPRGDR,MAS.ERR) ; * Tus End;* R22 UTILITY AUTO CONVERSION
    IF R.REDO.LY.MASTERPRGDR THEN
        Y.US.PROGRAM = R.REDO.LY.MASTERPRGDR<REDO.MASPRG.MASTER.PRG>
    END

RETURN

*-------------
CHECK.LIM.USE:
*-------------

    IF Y.POINT LT Y.POINT.MIN OR Y.POINT GT Y.POINT.MAX THEN
        AF = REDO.PT.US.QTYORVAL.TO.US
        ETEXT = 'EB-REDO.LY.V.QUANTITY.US5':@FM:Y.POINT.MIN:@VM:Y.POINT.MAX
        CALL STORE.END.ERROR
        RETURN
    END

RETURN

*------------------------------------------------------------------------------------
END
