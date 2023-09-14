* @ValidationCode : MjotMjQyODU1OTI4OkNwMTI1MjoxNjkwMTY3NTM5NjU4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:28:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>48</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ALERTA.REPRECIO.POST

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - FM to @FM
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.COMPANY
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.ST.L.APAP.COVI.PRELACIONIII
    $INSERT I_L.APAP.CAMPO.CUOTA.PROG.COMMON
    $INSERT I_F.L.APAP.REP.MANUAL
    $INSERT I_F.USER

    GOSUB INIT

*****************************************
    ARR.ID = R.NEW(AA.ARR.ACT.ARRANGEMENT)
    Y.ACTIVITY.EXECUTE = R.NEW(AA.ARR.ACT.ACTIVITY)
    Y.ACTIVITY = ID.NEW
    Y.ESTATUS = R.NEW(AA.ARR.ACT.RECORD.STATUS)
    Y.DATE.TIME = R.NEW(AA.ARR.ACT.DATE.TIME)
***********************************************

    IF Y.ACTIVITY.EXECUTE EQ 'LENDING-CHANGE-PRINCIPALINT' OR Y.ACTIVITY.EXECUTE EQ 'LENDING-CHANGE-PENALTINT' THEN
        GOSUB MAIN
    END

RETURN

INIT:
****

    FN.AA.ARR.INTEREST = 'F.AA.ARR.INTEREST'
    F.AA.ARR.INTEREST = ''
    CALL OPF(FN.AA.ARR.INTEREST,F.AA.ARR.INTEREST)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.PAYMENT.SCHEDULE = "F.AA.ARR.PAYMENT.SCHEDULE"
    F.AA.PAYMENT.SCHEDULE  = ""
    R.AA.PAYMENT.SCHEDULE  = ""

    FN.AA.ARRANGEMENT.DATED.XREF  = 'F.AA.ARRANGEMENT.DATED.XREF'
    F.AA.ARRANGEMENT.DATED.XREF = ''
    CALL OPF(FN.AA.ARRANGEMENT.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.L.APAP.REP.MANUAL = 'F.ST.L.APAP.REP.MANUAL'
    F.L.APAP.REP.MANUAL = ''
    CALL OPF (FN.L.APAP.REP.MANUAL,F.L.APAP.REP.MANUAL)

RETURN


MAIN:
****
    Y.CONTINUE = 'NO';
    R.AA.ARR.XREF = '';
    CALL F.READ(FN.AA.ARRANGEMENT.DATED.XREF,ARR.ID,R.AA.ARR.XREF,F.AA.ARRANGEMENT.DATED.XREF,R.AA.ARR.XREF.ERR);

    IF Y.ACTIVITY.EXECUTE EQ 'LENDING-CHANGE-PRINCIPALINT' THEN

        INT.POS = '';
        LOCATE 'PRINCIPALINT' IN R.AA.ARR.XREF<1,1> SETTING INT.POS THEN
            Y.CONTINUE = 'YES';

            Y.FECHA.CONTADOR = R.AA.ARR.XREF<2,INT.POS,1>;
            Y.FECHA.CONTADOR = CHANGE(Y.FECHA.CONTADOR,'.',@FM);
            Y.FECHA          = Y.FECHA.CONTADOR<1>
            Y.CONTADOR       = Y.FECHA.CONTADOR<2>
            Y.CONTADOR       = Y.CONTADOR + 1;

*Si el ultimo de registro de la tabla ARR.REF es distinto al dia de hoy, significa que sera el primer registro .1 del dia de la ejecucion. De lo contrario, se le sumara +1 al ultimo registro.
            IF Y.FECHA NE TODAY THEN
                AA.ARR.INT.ID = ARR.ID:'-PRINCIPALINT-':TODAY:'.1';
            END ELSE
                AA.ARR.INT.ID = ARR.ID:'-PRINCIPALINT-':Y.FECHA:'.':Y.CONTADOR;
            END
       

        END

    END ELSE IF Y.ACTIVITY.EXECUTE EQ 'LENDING-CHANGE-PENALTINT' THEN

        INT.POS = '';
        LOCATE 'PENALTINT' IN R.AA.ARR.XREF<1,1> SETTING INT.POS THEN
            Y.CONTINUE = 'YES';

            Y.FECHA.CONTADOR = R.AA.ARR.XREF<2,INT.POS,1>;
            Y.FECHA.CONTADOR = CHANGE(Y.FECHA.CONTADOR,'.',@FM);
            Y.FECHA          = Y.FECHA.CONTADOR<1>
            Y.CONTADOR       = Y.FECHA.CONTADOR<2>
            Y.CONTADOR       = Y.CONTADOR + 1;

*Si el ultimo de registro de la tabla ARR.REF es distinto al dia de hoy, significa que sera el primer registro .1 del dia de la ejecucion. De lo contrario, se le sumara +1 al ultimo registro.
            IF Y.FECHA NE TODAY THEN
                AA.ARR.INT.ID = ARR.ID:'-PENALTINT-':TODAY:'.1';
            END ELSE
                AA.ARR.INT.ID = ARR.ID:'-PENALTINT-':Y.FECHA:'.':Y.CONTADOR;
            END

        END

    END

    IF Y.CONTINUE EQ 'YES' THEN
        GOSUB INSERT.TABLE.REPRECIO
    END

RETURN

INSERT.TABLE.REPRECIO:
**********************
    R.L.APAP.REP.MANUAL<ST.L.A6.ACTIVIDAD>    = Y.ACTIVITY;
    R.L.APAP.REP.MANUAL<ST.L.A6.ESTADO>       = 'NOPROCESADO';
    R.L.APAP.REP.MANUAL<ST.L.A6.FECHA>        = TODAY;
    R.L.APAP.REP.MANUAL<ST.L.A6.ARRANGEMENT>  = ARR.ID;

*Auditorias
    R.L.APAP.REP.MANUAL<ST.L.A6.INPUTTER>   = OPERATOR;
    R.L.APAP.REP.MANUAL<ST.L.A6.AUTHORISER> = OPERATOR;
    R.L.APAP.REP.MANUAL<ST.L.A6.DATE.TIME>  = Y.DATE.TIME;
    R.L.APAP.REP.MANUAL<ST.L.A6.CO.CODE>    = ID.COMPANY;
    R.L.APAP.REP.MANUAL<ST.L.A6.DEPT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>

    CALL F.WRITE(FN.L.APAP.REP.MANUAL,AA.ARR.INT.ID,R.L.APAP.REP.MANUAL);

RETURN

END
