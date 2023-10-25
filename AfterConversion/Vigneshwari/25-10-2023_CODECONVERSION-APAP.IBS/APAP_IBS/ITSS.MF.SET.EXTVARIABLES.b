* @ValidationCode : Mjo1NjAwNTEzNzY6Q3AxMjUyOjE2OTgyMzc2NjMxNTM6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Oct 2023 18:11:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.MF.SET.EXTVARIABLES(USER.ID)


*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                   FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.EXTERNAL.USER
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_EB.MOB.FRMWRK.COMMON


*EB.EXTERNAL$USER.ID,
*EB.EXTERNAL$CUSTOMER,
*EB.EXTERNAL$ACCOUNTS,
*EB.EXTERNAL$ACCOUNT.TITLES,
*EB.EXTERNAL$CHANNEL,
*EB.EXTERNAL$CHANNEL.TYPE,
*EXT.EXTERNAL.USER
*EXT.ARRANGEMENT
*EXT.CUSTOMER
*EXT.SMS.EXTERNAL.CUSTOMER
*EXT.CUSTOMER.ACCOUNTS
*EXT.CUSTOMER.ACCOUNTS.TITLES
*EXT.SMS.CUSTOMERS
*EXT.SMS.CUSTOMER.ARRANGEMENTS
    MOB.USER.VARIABLES<1,1> = 'EXT.EXTERNAL.USER'
    MOB.USER.VARIABLES<2,1> = 'EXT.ARRANGEMENT'
    MOB.USER.VARIABLES<3,1> = 'EXT.CUSTOMER'
    MOB.USER.VARIABLES<4,1> = 'EXT.SMS.EXTERNAL.CUSTOMER'
    MOB.USER.VARIABLES<5,1> = 'EXT.CUSTOMER.ACCOUNTS'
    MOB.USER.VARIABLES<6,1> = 'EXT.CUSTOMER.ACCOUNTS.TITLES'
    MOB.USER.VARIABLES<7,1> = 'EXT.SMS.CUSTOMERS'
    MOB.USER.VARIABLES<8,1> = 'EXT.SMS.CUSTOMER.ARRANGEMENTS'
    MOB.USER.VARIABLES<9,1> = 'EXT.SMS.TODAY'

    GOSUB INITIALISE

    GOSUB PROCESS

    GOSUB SET.SESSION.VARS

    RETURN

INITIALISE:

    EB.EXTERNAL$USER.ID = USER.ID
    MOB.USER.VARIABLES<1,2> = USER.ID
    EB.EXTERNAL$CUSTOMER = R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>
    MOB.USER.VARIABLES<2,2> =  R.EB.EXTERNAL.USER<EB.XU.ARRANGEMENT>
    MOB.USER.VARIABLES<3,2> = EB.EXTERNAL$CUSTOMER
    MOB.USER.VARIABLES<4,2> = EB.EXTERNAL$CUSTOMER
    MOB.USER.VARIABLES<7,2> = EB.EXTERNAL$CUSTOMER
    MOB.USER.VARIABLES<8,2> = 'EXT.SMS.CUSTOMER.ARRANGEMENTS'
    MOB.USER.VARIABLES<9,2> = TODAY


    FN.CUST.ACCT = 'F.CUSTOMER.ACCOUNT'
    F.CUST.ACCT = ''
    CALL OPF(FN.CUST.ACCT, F.CUST.ACCT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)


    RETURN

PROCESS:

    E.CUS.ACC = ''
    CALL F.READ(FN.CUST.ACCT, EB.EXTERNAL$CUSTOMER, R.CUST.ACCT, F.CUST.ACCT, E.CUS.ACC)

    IF NOT(E.CUS.ACC) THEN
        EB.EXTERNAL$ACCOUNTS = LOWER(LOWER(LOWER(R.CUST.ACCT)))
        MOB.USER.VARIABLES<5,2> =  EB.EXTERNAL$ACCOUNTS
        ACC.CNT = DCOUNT(R.CUST.ACCT, @FM)
        FOR I=1 TO ACC.CNT
            ACCT.ID = R.CUST.ACCT<I>
            E.ACC = ''
          *  CALL F.READ(FN.ACCOUNT, ACCT.ID, R.ACCOUNT, F.ACCOUNT, E.ACC)
          READ R.ACCOUNT FROM F.ACCOUNT, ACCT.ID ELSE E.ACC = 'RECORD NOT FOUND'
            IF NOT(E.ACC) THEN
                ACCT.TITLES<-1> = ACCT.ID:' ':R.ACCOUNT<AC.SHORT.TITLE>
            END
        NEXT I
        EB.EXTERNAL$ACCOUNT.TITLES = LOWER(LOWER(LOWER(ACCT.TITLES)))
        MOB.USER.VARIABLES<6,2> = EB.EXTERNAL$ACCOUNT.TITLES
    END

    RETURN

SET.SESSION.VARS:

    USRVARSCNT = DCOUNT(MOB.USER.VARIABLES, @FM)

    FOR I=1 TO USRVARSCNT
        CALL System.setVariable(MOB.USER.VARIABLES<I, 1>, MOB.USER.VARIABLES<I, 2>)
    NEXT I

    Y.NAME = ""
    Y.VALUES = ""
    CALL System.getUserVariables(Y.NAME ,Y.VALUES)

    RETURN
END
