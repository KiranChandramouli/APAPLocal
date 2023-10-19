* @ValidationCode : Mjo5OTYyMTg0NjpDcDEyNTI6MTY4MTEyMjYxNDgxODozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 16:00:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.H.PROVISION.PARAMETER.AUTHORISE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.PROVISION.PARAMETER.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.H.PROVISION.PARAMETER.AUTHORISE is an authorisation routine attached to the TEMPLATE
*                    - REDO.H.PROVISION.PARAMETER; the routine updates the frequency to the batch file
*Linked With       : TEMPLATE-REDO.H.PROVISION.PARAMETER
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.H.PROVISION.PARAMETER             As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 24 Sep 2010        Mudassir V         ODR-2010-09-0167 B.23B        Initial Creation
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             ++ TO +=
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*******************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*-------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    GOSUB GET.FREQUENCY

RETURN
*-------------------------------------------------------------------------------------------------------
**************
GET.FREQUENCY:
**************
    FLAG = '' ; Y.VAL.DT.TYPE = ''
    Y.DATE.FREQ = R.NEW(PROV.COB.FREQUENCY)
    Y.FREQ = Y.DATE.FREQ[9,LEN(Y.DATE.FREQ)]

    COMI = Y.DATE.FREQ
    CALL CFQ
    Y.NEXT.RUN.DATE = COMI[1,8]

    BEGIN CASE
        CASE Y.FREQ EQ 'DAILY'
            GOSUB HOLIDAY.CHECK.DAILY
        CASE Y.FREQ NE 'DAILY'
            GOSUB HOLIDAY.CHECK
    END CASE
    R.NEW(PROV.NEXT.RUN.DATE) = Y.NEXT.RUN.DATE

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
                Y.COUNT += 1 ;*AUTO R22 CODE CONVERSION
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
*-------------------------------------------------------------------------
END
