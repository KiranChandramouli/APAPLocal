SUBROUTINE REDO.APAP.INVST.PROV.POST
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.INVST.PROVISIONING.P
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.B.INVST.PROVISIONING.POSTRTN is the post routine to update the local file
*                    REDO.H.PROVISION.PARAMETER
*Linked With       : Batch BNK/REDO.B.INVST.PROVISIONING
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.H.PROVISION.PARAMETER      As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                    Reference                  Description
*   ------               -----                 -------------               -------------
* 27 Sep 2010        Shiva Prasad Y        ODR-2010-09-0167 B.23B         Initial Creation
* 14 May 2011        Sudharsanan S            PACS00061656                Parameter table - @ID changed to 'SYSTEM'
* 28 Jun 2011        Bharath G                PACS00074264                This routine missed in previous pack. Sending this routine
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_REDO.APAP.B.INVST.PROVISIONING.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.REDO.H.PROVISION.PARAMETER = 'F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER  = '' ; FLAG = '' ; Y.VAL.DT.TYPE = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER,F.REDO.H.PROVISION.PARAMETER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
*PACS00061656 - S
    REDO.H.PROVISION.PARAMETER.ID = "SYSTEM"
    GOSUB READ.REDO.H.PROVISION.PARAMETER
*PACS00061656 - E

    Y.DATE.FREQ     = R.REDO.H.PROVISION.PARAMETER<PROV.COB.FREQUENCY>
    Y.NEXT.RUN.DATE = R.REDO.H.PROVISION.PARAMETER<PROV.NEXT.RUN.DATE>

    Y.FREQ = Y.DATE.FREQ[9,LEN(Y.DATE.FREQ)]

    IF NOT(Y.NEXT.RUN.DATE) THEN
        Y.NEXT.RUN.DATE = R.REDO.H.PROVISION.PARAMETER<PROV.NEXT.RUN.DATE>
    END

    IF Y.NEXT.RUN.DATE GT TODAY THEN
        RETURN
    END

    COMI = Y.NEXT.RUN.DATE:Y.FREQ
    CALL CFQ
    Y.NEXT.RUN.DATE = COMI[1,8]

    BEGIN CASE
        CASE Y.FREQ EQ 'DAILY'
            GOSUB HOLIDAY.CHECK.DAILY
        CASE Y.FREQ NE 'DAILY'
            GOSUB HOLIDAY.CHECK
    END CASE

    R.REDO.H.PROVISION.PARAMETER<PROV.NEXT.RUN.DATE> = Y.NEXT.RUN.DATE
    GOSUB WRITE.REDO.H.PROVISION.PARAMETER

RETURN

*-------------------------------------------------------------------------
HOLIDAY.CHECK.DAILY:
*-------------------------------------------------------------------------
    Y.COUNT = 1
    LOOP
    WHILE Y.VAL.DT.TYPE NE 'W'
        Y.REGION = ''
        CALL AWD(Y.REGION,Y.NEXT.RUN.DATE,Y.VAL.DT.TYPE)
        Y.DIFF = Y.NEXT.RUN.DATE
        DAYS = '-':Y.COUNT:'C'

        IF FLAG EQ '' THEN
            CALL CDT('',Y.DIFF,DAYS)
        END
        IF Y.VAL.DT.TYPE EQ 'H' THEN
            IF Y.DIFF EQ TODAY THEN
                CALL CDT('',Y.NEXT.RUN.DATE,'+1C')
                Y.COUNT += 1
            END ELSE
                CALL CDT('',Y.NEXT.RUN.DATE,'-1C')
            END
        END
    REPEAT
RETURN
*-------------------------------------------------------------------------
HOLIDAY.CHECK:
*-------------------------------------------------------------------------
    LOOP
    WHILE Y.VAL.DT.TYPE NE 'W'
        Y.REGION = ''
        CALL AWD(Y.REGION,Y.NEXT.RUN.DATE,Y.VAL.DT.TYPE)
        IF Y.VAL.DT.TYPE EQ 'H' THEN
            CALL CDT('',Y.NEXT.RUN.DATE,'-1C')
        END
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------------
********************************
READ.REDO.H.PROVISION.PARAMETER:
********************************
    R.REDO.H.PROVISION.PARAMETER  = ''
    REDO.H.PROVISION.PARAMETER.ER = ''
    CALL CACHE.READ(FN.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ID,R.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************************
WRITE.REDO.H.PROVISION.PARAMETER:
*********************************
    CALL F.WRITE(FN.REDO.H.PROVISION.PARAMETER,REDO.H.PROVISION.PARAMETER.ID,R.REDO.H.PROVISION.PARAMETER)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
