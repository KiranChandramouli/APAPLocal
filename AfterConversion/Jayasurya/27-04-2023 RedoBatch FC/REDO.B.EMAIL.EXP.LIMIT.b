* @ValidationCode : MjotMTQwNzczODQ2ODpDcDEyNTI6MTY4MTE5MDY2Nzc4NjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:54:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.EMAIL.EXP.LIMIT(ID.LIMITS)

*-----------------------------------------------------------------------------
* Company Name  : APAP
* Developed By  : Balagurunathan
*-----------------------------------------------------------------
* Description :
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* PACS00242938        23-Jan-2013           Cob job to raise email
* Date                  who                   Reference              
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - VM TO @VM AND FM TO @FM
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.APAP.FX.BRN.COND
    $INSERT I_F.REDO.APAP.FX.BRN.POSN
    $INSERT I_F.REDO.APAP.USER.LIMITS
    $INSERT I_REDO.B.EMAIL.EXP.LIMIT.COMMON
    $INSERT I_F.REDO.MM.CUST.LIMIT


    Y.ID=FIELD(ID.LIMITS,'*',1)
    Y.TABLE=FIELD(ID.LIMITS,'*',2)
    Y.BODY=''

    IF Y.ID EQ '' OR Y.TABLE EQ '' THEN

        RETURN
    END



    BEGIN CASE


        CASE Y.TABLE EQ 'REDO.APAP.FX.BRN.COND'
            GOSUB FX.BRN.COND


        CASE Y.TABLE EQ 'REDO.APAP.FX.BRN.POSN'

            GOSUB FX.BRN.POSN

        CASE Y.TABLE EQ 'REDO.APAP.USER.LIMITS'
            GOSUB USER.LIMIT


        CASE Y.TABLE EQ 'REDO.MM.CUST.LIMIT'
            GOSUB CUST.LIMIT

        CASE 1

    END CASE

RETURN


FX.BRN.COND:
    CALL F.READ(FN.REDO.APAP.FX.BRN.COND,Y.ID,R.REDO.APAP.FX.BRN.COND,F.REDO.APAP.FX.BRN.COND,ERR)
    EXP.DATE= R.REDO.APAP.FX.BRN.COND<REDO.BRN.COND.OVR.VALID.DATE>
    Y.TO.MAIL=R.REDO.APAP.FX.BRN.COND<REDO.BRN.COND.EMAIL.ID>


    EXP.DATE=TRIM(EXP.DATE)
    IF EXP.DATE LE TOD.DATE AND EXP.DATE NE '' THEN
        Y.BODY=Y.MAIL.BODY : ' REDO.APAP.FX.BRN.COND Record ' : Y.ID


        GOSUB MAIL.GENERATE


    END


RETURN

FX.BRN.POSN:

    CALL F.READ(FN.REDO.APAP.FX.BRN.POSN,Y.ID,R.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN,ERR)

    EXP.DATE=R.REDO.APAP.FX.BRN.POSN<REDO.BRN.POSN.BRN.LIM.VALID.DATE>
    Y.TO.MAIL=R.REDO.APAP.FX.BRN.POSN<REDO.BRN.POSN.MAIL.ID>



    EXP.DATE=TRIM(EXP.DATE)
    IF EXP.DATE LE TOD.DATE AND EXP.DATE NE '' THEN
        Y.BODY=Y.MAIL.BODY : ' REDO.APAP.FX.BRN.POSN Record ' : Y.ID


        GOSUB MAIL.GENERATE


    END

RETURN


USER.LIMIT:
**********


    CALL F.READ(FN.REDO.APAP.USER.LIMITS,Y.ID,R.REDO.APAP.USER.LIMITS,F.REDO.APAP.USER.LIMITS,ERR)

    Y.TO.MAIL=R.REDO.APAP.USER.LIMITS<REDO.USR.LIM.USR.EMAIL>

    EXP.DAT.ARR1=R.REDO.APAP.USER.LIMITS<REDO.USR.LIM.SIN.TXN.LIM.DATE>
    EXP.DAT.ARR2=R.REDO.APAP.USER.LIMITS<REDO.USR.LIM.TOT.TXN.LIM.DATE>
    EXP.DAT.ARR3=R.REDO.APAP.USER.LIMITS<REDO.USR.LIM.TRA.LIM.VALID.DATE>
    EXP.DAT.ARR4=R.REDO.APAP.USER.LIMITS<REDO.USR.LIM.BPS.LIM.VALID.DATE>


    CHANGE @VM TO @FM IN EXP.DAT.ARR1
    CHANGE @VM TO @FM IN EXP.DAT.ARR2
    CHANGE @VM TO @FM IN EXP.DAT.ARR3
    CHANGE @VM TO @FM IN EXP.DAT.ARR4


    EXP.DAT.ARR=EXP.DAT.ARR1
    EXP.DAT.ARR<-1>=EXP.DAT.ARR2
    EXP.DAT.ARR<-1>=EXP.DAT.ARR3
    EXP.DAT.ARR<-1>=EXP.DAT.ARR4

    Y.FLAG=0
    LOOP

        REMOVE EXP.DATE FROM EXP.DAT.ARR  SETTING POS.USR

    WHILE EXP.DATE:POS.USR
        EXP.DATE=TRIM(EXP.DATE)
        IF EXP.DATE LE TOD.DATE AND EXP.DATE NE '' THEN
* Y.SUBJECT=Y.MAIL.SUBJECT
*            Y.BODY=Y.MAIL.BODY : ' REDO.MM.CUST.LIMIT Record ' : ID.LIMIT

            Y.FLAG=1

*            GOSUB MAIL.GENERATE


        END



    REPEAT

    IF Y.FLAG THEN

        Y.BODY=Y.MAIL.BODY : ' REDO.APAP.USER.LIMITS Record ' : Y.ID
        GOSUB MAIL.GENERATE

    END




RETURN

CUST.LIMIT:
***********

    CALL F.READ(FN.REDO.MM.CUST.LIMIT,Y.ID,R.REDO.MM.CUST.LIMIT,F.REDO.MM.CUST.LIMIT,ERR)

    Y.ID.LIMIT=R.REDO.MM.CUST.LIMIT<CUST.LIM.LIMIT.ID>


    Y.TO.MAIL=R.REDO.MM.CUST.LIMIT<CUST.LIM.MAIL.ID>

    CALL F.READ(FN.CUSTOMER,Y.ID,R.CUSTOMER,F.CUSTOMER,ERR)

    CUST.NAME=R.CUSTOMER<EB.CUS.SHORT.NAME>

    CUST.NAME1=TRIM(CUST.NAME<1,1>)
    CUST.NAME2=TRIM(CUST.NAME<1,2> )
    CUST.NAME=CUST.NAME2

    IF CUST.NAME2 EQ '' THEN

        CUST.NAME=CUST.NAME1

    END

    Y.FLAG=0

    LOOP

        REMOVE ID.LIMIT FROM Y.ID.LIMIT SETTING POS.LIM

    WHILE ID.LIMIT:POS.LIM
        Y.BODY=''
        CALL F.READ(FN.LIMIT,ID.LIMIT,R.LIMIT,F.LIMIT,ERR)

        EXP.DATE=R.LIMIT<LI.EXPIRY.DATE>

        EXP.DATE=TRIM(EXP.DATE)
        IF EXP.DATE LE TOD.DATE AND EXP.DATE NE '' THEN
*            Y.BODY=Y.MAIL.BODY : ' REDO.MM.CUST.LIMIT Record ' : Y.ID :CUST.NAME

            Y.FLAG=1
*           GOSUB MAIL.GENERATE


        END

    REPEAT

    IF Y.FLAG THEN

        Y.BODY=Y.MAIL.BODY : ' REDO.MM.CUST.LIMIT Record ' : Y.ID : " " : CUST.NAME
        GOSUB MAIL.GENERATE

    END




RETURN

MAIL.GENERATE:

    Y.SUBJECT=Y.MAIL.SUBJECT

    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    Y.TEMP.ID = UNIQUE.TIME
    FILENAME  = UNIQUE.TIME
    CHANGE @VM TO ',' IN Y.TO.MAIL
    RECORD = Y.FROM.MAIL:"#":Y.TO.MAIL:"#":Y.SUBJECT:"#":Y.BODY
    WRITE RECORD TO F.HRMA.FILE,FILENAME

RETURN


RETURN


END