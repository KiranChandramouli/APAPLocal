* @ValidationCode : MjozNTU5ODk5NTI6Q3AxMjUyOjE2ODIzMzU5NDU2MTU6SVRTUzotMTotMTo2NjQ6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 664
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED , VM TO @VM, FM TO @FM
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE LAPAP.AA.DELETE.PAYM.EMPTY

    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.COMPANY
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.PAYMENT.SCHEDULE ;* AUTO R22 CODE CONVERSION END

    GOSUB INIT
    GOSUB MAIN

RETURN

INIT:
****

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.PAYMENT.SCHEDULE = "F.AA.ARR.PAYMENT.SCHEDULE"
    F.AA.PAYMENT.SCHEDULE  = ""
    R.AA.PAYMENT.SCHEDULE  = ""

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.CHK.DIR1.REV = "&COMO&";
    F.CHK.DIR1.REV = "";
    CALL OPF(FN.CHK.DIR1.REV,F.CHK.DIR1.REV)

RETURN

MAIN:
*****
    Y.ARREGLO           = '';
    Y.ARRANGEMENT.ID    = c_aalocArrId;

    IF c_aalocArrActivityRec<AA.ARR.ACT.ACTIVITY.CLASS> EQ 'LENDING-NEW-ARRANGEMENT' AND c_aalocActivityStatus EQ 'AUTH' THEN
        GOSUB CHECK.REPAYMENT.SCHEDULE
    END

RETURN

CHECK.REPAYMENT.SCHEDULE:
************************

    PAYMENT.SCHEDULE.ID = Y.ARRANGEMENT.ID:'-REPAYMENT.SCHEDULE-':TODAY:'.1';
    CALL F.READ(FN.AA.PAYMENT.SCHEDULE,PAYMENT.SCHEDULE.ID,R.AA.PAYMENT.SCHEDULE,F.AA.PAYMENT.SCHEDULE,ERR.AA.PAYMENT.SCHEDULE)

    Y.PAYMENT.TYPE =  R.AA.PAYMENT.SCHEDULE<AA.PS.PAYMENT.TYPE>
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,@SM,@FM)
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,@VM,@FM)

    Y.PAYMENT.FREQ  = R.AA.PAYMENT.SCHEDULE<AA.PS.PAYMENT.FREQ>
    Y.PAYMENT.FREQ = CHANGE(Y.PAYMENT.FREQ,@SM,@FM)
    Y.PAYMENT.FREQ = CHANGE(Y.PAYMENT.FREQ,@VM,@FM)

    Y.DCOUNT.FRECUENCY = DCOUNT(Y.PAYMENT.FREQ,@FM)
    Y.CNT1 = DCOUNT(Y.PAYMENT.TYPE,@FM);

    IF Y.DCOUNT.FRECUENCY GT Y.CNT1 THEN

        GOSUB CREATE.OFS.MESSAGE
        GOSUB SEND.OFS.MESSAGE

        IF Y.ARREGLO NE '' THEN
            GOSUB CHECK.ARCHIVO.FILES.REV
        END
    END

RETURN


CREATE.OFS.MESSAGE:
*******************

    Y.COMPANY = ID.COMPANY
    Y.ARREGLO<-1> = '|PRESTAMO [':Y.ARRANGEMENT.ID:'] CON INCONSISTENCIA EN EL PLAN DE PAGO.|';
    Y.OFS.QUEUE = "AA.ARRANGEMENT.ACTIVITY,AA.PRESTAMO/I/PROCESS//0/,//":Y.COMPANY:",,ARRANGEMENT:1:1=":Y.ARRANGEMENT.ID:",ACTIVITY:1:1=LENDING-CHANGE-REPAYMENT.SCHEDULE,PROPERTY:1:1=REPAYMENT.SCHEDULE,FIELD.NAME:1:1=PAYMENT.TYPE:":Y.DCOUNT.FRECUENCY:",FIELD.VALUE:1:1=|-|,"
    Y.ARREGLO<-1> = '|OFS.QUEUE.MESSAGE:':Y.OFS.QUEUE:'|';

RETURN

SEND.OFS.MESSAGE:
*****************

    options = 'AA.COB1'; RESP = '';
    CALL OFS.POST.MESSAGE(Y.OFS.QUEUE,RESP,options,COMM)
    Y.ARREGLO<-1> = '|RESPONSE.ID:':RESP:'|';

RETURN

CHECK.ARCHIVO.FILES.REV:
***********************
    HORA = TIME();
    R.FIL.REV = ''; READ.FIL.ERR.REV = ''; Y.FILE.NAME = Y.ARRANGEMENT.ID:'_PLAN_PAGO_VACIO_':HORA:'.txt';
    CALL F.READ(FN.CHK.DIR1.REV,Y.FILE.NAME,R.FIL.REV,F.CHK.DIR1.REV,READ.FIL.ERR.REV)
    IF R.FIL.REV THEN
        DELETE F.CHK.DIR1.REV,Y.FILE.NAME
    END

    WRITE Y.ARREGLO ON F.CHK.DIR1.REV, Y.FILE.NAME ON ERROR
        CALL OCOMO("Error en la escritura del archivo en el directorio":F.CHK.DIR1.REV)
    END

RETURN

END