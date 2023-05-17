SUBROUTINE REDO.LY.POINTS.E.HIS(R.DATA)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is an Nofile routine to get some data for enquiry REDO.LOY.INFOF360
* related to B.25 Loyalty Module
*
* Input/Output:
*-------------
* IN : CUSTOMER.ID / FROM.TO.DATE
* OUT : R.DATA (ALL DATA)
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
* 14-MAY-2013    RMONDRAGON              ODR-2011-06-0243        FIRST VERSION
*-----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.POINTS
* </region>
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*****
INIT:
*****

    Y.FROM.TO.DATE = ''
    Y.CUSTOMER.ID = ''
    Y.FIRST.DATE = 19000101
    Y.SECOND.DATE = 99991231

    IF LNGG EQ 1 THEN
        Y.STATUS1 = 'Generation'
        Y.STATUS2 = 'Availability'
        Y.STATUS3 = 'Expiration'
        Y.STATUS4 = 'Utilization'
        Y.STATUS5 = 'Submitted'
        Y.BAL.TITLE = 'BALANCE AT PERIOD'
    END ELSE
        Y.STATUS1 = 'Generacion'
        Y.STATUS2 = 'Disponibilidad'
        Y.STATUS3 = 'Expiracion'
        Y.STATUS4 = 'Utilizacion'
        Y.STATUS5 = 'Sometida'
        Y.BAL.TITLE = 'BALANCE EN EL PERIODO'
    END

RETURN

**********
OPENFILES:
**********

    FN.REDO.LY.PROGRAM = 'F.REDO.LY.PROGRAM'
    F.REDO.LY.PROGRAM = ''
    CALL OPF(FN.REDO.LY.PROGRAM,F.REDO.LY.PROGRAM)

    FN.REDO.LY.POINTS = 'F.REDO.LY.POINTS'
    F.REDO.LY.POINTS = ''
    CALL OPF(FN.REDO.LY.POINTS,F.REDO.LY.POINTS)

RETURN

********
PROCESS:
********

    LOCATE 'FROM.TO.DATE' IN D.FIELDS<1> SETTING FROM.TO.DATE.POS THEN
        Y.FROM.TO.DATE = D.RANGE.AND.VALUE<FROM.TO.DATE.POS>
    END

    LOCATE 'CUSTOMER.ID' IN D.FIELDS<1> SETTING CUSTOMER.ID.POS THEN
        Y.CUSTOMER.ID = D.RANGE.AND.VALUE<CUSTOMER.ID.POS>
    END

    IF Y.FROM.TO.DATE EQ '' AND Y.CUSTOMER.ID NE '' THEN
        GOSUB GET.ALL.DATA
        RETURN
    END

    IF Y.FROM.TO.DATE EQ '' AND Y.CUSTOMER.ID EQ '' THEN
        SEL.REC = 'SSELECT ':FN.REDO.LY.POINTS
    END

    IF Y.FROM.TO.DATE NE '' AND Y.CUSTOMER.ID EQ '' THEN
        GOSUB GET.DATES
        IF Y.RET EQ 1 THEN
            SEL.REC = 'SSELECT ':FN.REDO.LY.POINTS:' WITH GEN.DATE EQ ':Y.FIRST.DATE
        END ELSE
            IF Y.RET EQ 2 THEN
                SEL.REC = 'SSELECT ':FN.REDO.LY.POINTS:' WITH GEN.DATE GE ':Y.FIRST.DATE:' AND GEN.DATE LE ':Y.SECOND.DATE
            END ELSE
                RETURN
            END
        END
    END

    IF Y.FROM.TO.DATE NE '' AND Y.CUSTOMER.ID NE '' THEN
        GOSUB GET.DATES
        IF Y.RET EQ 1 THEN
            SEL.REC = 'SSELECT ':FN.REDO.LY.POINTS:' WITH @ID LIKE ':Y.CUSTOMER.ID:' AND GEN.DATE EQ ':Y.FIRST.DATE
        END ELSE
            IF Y.RET EQ 2 THEN
                SEL.REC = 'SSELECT ':FN.REDO.LY.POINTS:' WITH @ID LIKE ':Y.CUSTOMER.ID:' AND GEN.DATE GE ':Y.FIRST.DATE:' AND GEN.DATE LE ':Y.SECOND.DATE
            END ELSE
                RETURN
            END
        END
    END

    CALL EB.READLIST(SEL.REC,SEL.REC.LIST,'',SEL.REC.LIST.TOT,REC.ERR)
    IF SEL.REC.LIST.TOT NE 0 THEN
        Y.SEL.REC.LIST.CNT = 1
        LOOP
        WHILE Y.SEL.REC.LIST.CNT LE SEL.REC.LIST.TOT
            Y.CUSTOMER.ID = SEL.REC.LIST<Y.SEL.REC.LIST.CNT>
            GOSUB GET.ALL.DATA
            Y.SEL.REC.LIST.CNT += 1
        REPEAT
    END

RETURN

**********
GET.DATES:
**********

    Y.RET = 3
    Y.SPACE = DCOUNT(Y.FROM.TO.DATE,@SM)

    BEGIN CASE
        CASE Y.SPACE EQ 1
            Y.RET = 1
            Y.FIRST.DATE = FIELD(Y.FROM.TO.DATE,@SM,1)
            RETURN
        CASE Y.SPACE EQ 2
            Y.RET = 2
            Y.FIRST.DATE = FIELD(Y.FROM.TO.DATE,@SM,1)
            Y.SECOND.DATE = FIELD(Y.FROM.TO.DATE,@SM,2)
            RETURN
    END CASE

RETURN

*************
GET.ALL.DATA:
*************

    R.POINTS = ''; LY.ERR = ''
    CALL F.READ(FN.REDO.LY.POINTS,Y.CUSTOMER.ID,R.POINTS,F.REDO.LY.POINTS,LY.ERR)
    IF R.POINTS THEN

        Y.PRODUCT = R.POINTS<REDO.PT.PRODUCT>
        Y.PROGRAM = R.POINTS<REDO.PT.PROGRAM>
        Y.TXNS.ID = R.POINTS<REDO.PT.TXN.ID>
        Y.GENS.PTS = R.POINTS<REDO.PT.QUANTITY>
        Y.GENS.PTS.VAL = R.POINTS<REDO.PT.QTY.VALUE>
        Y.GENS.DATE = R.POINTS<REDO.PT.GEN.DATE>
        Y.AVAILS.PTS = R.POINTS<REDO.PT.QUANTITY>
        Y.AVAILS.PTS.VAL = R.POINTS<REDO.PT.QTY.VALUE>
        Y.AVAILS.DATE = R.POINTS<REDO.PT.AVAIL.DATE>
        Y.PTSS.STATUS = R.POINTS<REDO.PT.STATUS>

        GOSUB GET.DETAIL

    END

RETURN

***********
GET.DETAIL:
***********

    Y.GEN.PTS.TOT = 0; Y.GEN.PTS.VAL.TOT = 0
    Y.AVA.PTS.TOT = 0; Y.AVA.PTS.VAL.TOT = 0
    Y.DUE.PTS.TOT = 0; Y.DUE.PTS.VAL.TOT = 0
    Y.USE.PTS.TOT = 0; Y.USE.PTS.VAL.TOT = 0

    Y.PROD.TOT = DCOUNT(Y.PRODUCT,@VM)
    Y.PROD.CNT = 1
    LOOP
    WHILE Y.PROD.CNT LE Y.PROD.TOT
        Y.PRODUCT.SPEC = FIELD(Y.PRODUCT,@VM,Y.PROD.CNT)
        Y.PROG.SET = FIELD(Y.PROGRAM,@VM,Y.PROD.CNT)
        Y.TXNS.ID.SET = FIELD(Y.TXNS.ID,@VM,Y.PROD.CNT)
        Y.GENS.PTS.SET = FIELD(Y.GENS.PTS,@VM,Y.PROD.CNT)
        Y.GENS.PTS.VAL.SET = FIELD(Y.GENS.PTS.VAL,@VM,Y.PROD.CNT)
        Y.GENS.DATE.SET = FIELD(Y.GENS.DATE,@VM,Y.PROD.CNT)
        Y.PTSS.STATUS.SET = FIELD(Y.PTSS.STATUS,@VM,Y.PROD.CNT)
        Y.PROG.TOT = DCOUNT(Y.PROG.SET,@SM)
        Y.PROG.CNT = 1
        LOOP
        WHILE Y.PROG.CNT LE Y.PROG.TOT
            Y.GEN.DATE = FIELD(Y.GENS.DATE.SET,@SM,Y.PROG.CNT)

            IF Y.GEN.DATE GE Y.FIRST.DATE AND Y.GEN.DATE LE Y.SECOND.DATE THEN
                GOSUB PROCESS.REC
            END

            Y.PROG.CNT += 1
        REPEAT
        Y.PROD.CNT += 1
    REPEAT

    R.DATA<-1> = '**--------***--***--***--***--*--'
    Y.BALANCES.DISP = '**':Y.BAL.TITLE:'*':Y.GEN.PTS.TOT:'*':Y.GEN.PTS.VAL.TOT
    Y.BALANCES.DISP := '**':Y.AVA.PTS.TOT:'*':Y.AVA.PTS.VAL.TOT
    Y.BALANCES.DISP := '**':Y.DUE.PTS.TOT:'*':Y.DUE.PTS.VAL.TOT
    Y.BALANCES.DISP := '**':Y.USE.PTS.TOT:'*':Y.USE.PTS.VAL.TOT:'**'
    R.DATA<-1> = Y.BALANCES.DISP

RETURN

************
PROCESS.REC:
************

    Y.CUS.PROD = Y.CUSTOMER.ID:'-':Y.PRODUCT.SPEC
    Y.PROGRAM.ID = FIELD(Y.PROG.SET,@SM,Y.PROG.CNT)
    GOSUB GET.LY.PROGRAM
    Y.TXN.ID = FIELD(Y.TXNS.ID.SET,@SM,Y.PROG.CNT)
    Y.GEN.PTS = FIELD(Y.GENS.PTS.SET,@SM,Y.PROG.CNT)
    Y.GEN.PTS.VAL = FIELD(Y.GENS.PTS.VAL.SET,@SM,Y.PROG.CNT)
    IF Y.PROG.CNT EQ Y.PROG.TOT THEN
        Y.GEN.DATE.NEXT = FIELD(Y.GENS.DATE,@VM,Y.PROD.CNT+1)
        Y.GEN.DATE.NEXT = FIELD(Y.GEN.DATE.NEXT,@SM,1)
    END ELSE
        Y.GEN.DATE.NEXT = FIELD(Y.GENS.DATE.SET,@SM,Y.PROG.CNT+1)
    END
    Y.PTS.STATUS = FIELD(Y.PTSS.STATUS.SET,@SM,Y.PROG.CNT)

    Y.R.DATA.HEADER = Y.CUS.PROD:'*':Y.PROGRAM.NAME:'*':Y.TXN.ID

    IF Y.PTS.STATUS EQ 'Liberada' OR Y.PTS.STATUS EQ 'Pendiente.Someter' THEN
        R.DATA<-1> = Y.R.DATA.HEADER:'*':Y.GEN.PTS:'*':Y.GEN.PTS.VAL:'*':Y.GEN.DATE:'**********':Y.STATUS1
        Y.GEN.PTS.TOT += Y.GEN.PTS
        Y.GEN.PTS.VAL.TOT += Y.GEN.PTS.VAL
        R.DATA<-1> = Y.R.DATA.HEADER:'****':Y.GEN.PTS:'*':Y.GEN.PTS.VAL:'*':Y.GEN.DATE:'*******':Y.STATUS2
        Y.AVA.PTS.TOT += Y.GEN.PTS
        Y.AVA.PTS.VAL.TOT += Y.GEN.PTS.VAL
    END

    IF Y.PTS.STATUS EQ 'No.Liberada' THEN
        R.DATA<-1> = Y.R.DATA.HEADER:'*':Y.GEN.PTS:'*':Y.GEN.PTS.VAL:'*':Y.GEN.DATE:'**********':Y.STATUS1
        Y.GEN.PTS.TOT += Y.GEN.PTS
        Y.GEN.PTS.VAL.TOT += Y.GEN.PTS.VAL
    END

    IF Y.PTS.STATUS EQ 'Expirada' THEN
        R.DATA<-1> = Y.R.DATA.HEADER:'*******':Y.GEN.PTS:'*':Y.GEN.PTS.VAL:'*':Y.GEN.DATE:'****':Y.STATUS3
        Y.DUE.PTS.TOT += Y.GEN.PTS
        Y.DUE.PTS.VAL.TOT += Y.GEN.PTS.VAL
    END

    IF Y.PTS.STATUS EQ 'Sometida' THEN
        R.DATA<-1> = Y.R.DATA.HEADER:'*':Y.GEN.PTS:'*':Y.GEN.PTS.VAL:'*':Y.GEN.DATE:'**********':Y.STATUS1
        Y.GEN.PTS.TOT += Y.GEN.PTS
        Y.GEN.PTS.VAL.TOT += Y.GEN.PTS.VAL
        R.DATA<-1> = Y.R.DATA.HEADER:'****':Y.GEN.PTS:'*':Y.GEN.PTS.VAL:'*':Y.GEN.DATE:'*******':Y.STATUS2
        Y.AVA.PTS.TOT += Y.GEN.PTS
        Y.AVA.PTS.VAL.TOT += Y.GEN.PTS.VAL
        R.DATA<-1> = Y.R.DATA.HEADER:'**********':Y.GEN.PTS:'*':Y.GEN.PTS.VAL:'**':Y.STATUS5
        Y.USE.PTS.TOT += Y.GEN.PTS
        Y.USE.PTS.VAL.TOT += Y.GEN.PTS.VAL
    END

    IF FIELD(Y.PTS.STATUS,'.',1) EQ 'Utilizada' THEN
        Y.USE.DATE = FIELD(Y.PTS.STATUS,'.',2)
        R.DATA<-1> = Y.R.DATA.HEADER:'**********':Y.GEN.PTS:'*':Y.GEN.PTS.VAL:'*':Y.USE.DATE:'*':Y.STATUS4
        Y.USE.PTS.TOT += Y.GEN.PTS
        Y.USE.PTS.VAL.TOT += Y.GEN.PTS.VAL
    END

RETURN

***************
GET.LY.PROGRAM:
***************

    R.LY.PROGRAM = ''; LOY.ERR = ''
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.PROGRAM.ID,R.LY.PROGRAM,F.REDO.LY.PROGRAM,LOY.ERR)
    IF R.LY.PROGRAM THEN
        Y.PROGRAM.NAME = R.LY.PROGRAM<REDO.PROG.NAME>
    END

RETURN

END
