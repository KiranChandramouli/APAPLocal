*-----------------------------------------------------------------------------
* <Rating>268</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE E.ISO.ATM.BAL.ENQ.BLD.RTN(Y.ID.LIST)
*Modification History
*  Date       Who                  Reference           Description
* 24 Aug 2011 Balagurunathan       ODR-2010-08-0469    PACS000104776  made changes to avoid sending unique key when rejected
* 22/01/2019  Vignesh Kumaar M R                       BRD003 [UNARED]
*-------------------------------------------------------------------------
*This is the enquiry rtn to return the balance of each account
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.INTERCO.PARAMETER
    $INSERT I_F.POSTING.RESTRICT
    $INSERT I_ATM.BAL.ENQ.COMMON
    $INSERT I_AT.ISO.COMMON

    GOSUB INITIALISE

    RETURN

*---------*
INITIALISE:
*---------*
*Y.ID.LIST = ''
    Y.ERR =''
    ENQ.Y.CHRG.AMT=''
    ISO.RESP ='00'

    ENQ.NAME=ENQ.SELECTION<1>
*
    SEL.ACCOUNT = 'ACCOUNT'
    FIND SEL.ACCOUNT IN ENQ.SELECTION SETTING Y.AC.POS1,Y.AC.POS ELSE Y.AC.POS =''

    IF Y.AC.POS THEN
        I1LOOP.CNT=DCOUNT(ENQ.SELECTION<4,Y.AC.POS>,' ')
        FOR II =1 TO I1LOOP.CNT
            Y.ACCT.NO =FIELD(ENQ.SELECTION<4,Y.AC.POS>,' ',II)
            IF Y.ACCT.NO THEN
                CHANGE '"' TO '' IN Y.ACCT.NO
                ACCT.LEN = R.INTERCO.PARAMETER<ST.ICP.ACCOUNT.NO.LENGTH>

                FN.ACCOUNT = 'F.ACCOUNT'
                F.ACCOUNT = ''
                CALL OPF(FN.ACCOUNT,F.ACCOUNT)    ;*open after changing company
*
                GOSUB PROCESS
            END
        NEXT II
        RETURN
    END

    IF NOT(Y.AC.POS) THEN

        BALANCE.FORMATTED = '00000000000000000000000'
*   Y.UNIQUE.ID = '111111'
        ENQ.ERROR.COM='EB-INVALD.DC.NUMBER'
        ETEXT1=ENQ.ERROR.COM
        ETEXT=ENQ.ERROR.COM
        CALL EB.GET.ERROR.MESSAGE(ETEXT1)
        ENQ.ERROR.COM=ETEXT1<1,1>
        CALL REDO.GET.ISO.RESP(ENQ.ERROR.COM)

        ISO.RESP=ENQ.ERROR.COM<1>
        ENQ.ERROR.COM=ENQ.ERROR.COM<2>

        Y.ID.LIST<-1> = 'BALANCE:1:1=':BALANCE.FORMATTED:',':'UNIQUE.TXN.CODE:1:1=':Y.UNIQUE.ID:',':'Y.ISO.RESPONSE:1:1=':ISO.RESP
        ETEXT=''

        RETURN
    END


    RETURN          ;*From initialise
*------------------------------------------------------------------------*

PROCESS:
*------*

    IF Y.ACCT.NO THEN
        CACHE.OFF =1

    END ELSE
        RETURN
    END

    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCT,F.ACCOUNT,AC.ER)
    IF R.ACCT EQ '' AND Y.ACCT.NO EQ AT$INCOMING.ISO.REQ(2) THEN
        CALL REDO.ATM.CARD.ACCT(Y.ACCT.NO,RTRN.ACCT.NO)
        Y.ACCT.NO=RTRN.ACCT.NO
        CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCT,F.ACCOUNT,AC.ER)
    END
    CACHE.OFF = 0
    Y.UNIQUE.ID=''

    IF R.ACCT THEN

* Fix for 2795723 [BRD003 UNARED #1]

        FN.REDO.ATM.WAIVE.CHARGE = 'F.REDO.ATM.WAIVE.CHARGE'
        F.REDO.ATM.WAIVE.CHARGE  = ''
        CALL OPF(FN.REDO.ATM.WAIVE.CHARGE,F.REDO.ATM.WAIVE.CHARGE)

        GET.TERMINAL.ID  = TRIM(AT$INCOMING.ISO.REQ(41))
        GET.TRANS.SOURCE = AT$INCOMING.ISO.REQ(32)
        ATM.WAIVE = GET.TERMINAL.ID:'-':GET.TRANS.SOURCE
        CALL F.READ(FN.REDO.ATM.WAIVE.CHARGE,ATM.WAIVE,R.REDO.ATM.WAIVE.CHARGE,F.REDO.ATM.WAIVE.CHARGE,ERR.REDO.ATM.WAIVE.CHARGE)

        IF NOT(R.REDO.ATM.WAIVE.CHARGE) THEN
            ERR.REDO.ATM.WAIVE.CHARGE = ''
            ATM.WAIVE = GET.TERMINAL.ID[1,4]:'*-':GET.TRANS.SOURCE
            CALL F.READ(FN.REDO.ATM.WAIVE.CHARGE,ATM.WAIVE,R.REDO.ATM.WAIVE.CHARGE,F.REDO.ATM.WAIVE.CHARGE,ERR.REDO.ATM.WAIVE.CHARGE)
        END

        IF ERR.REDO.ATM.WAIVE.CHARGE THEN
            CALL REDO.ENQ.CHG(R.ACCT)   ;* this routine is to raise charge if applicable
        END

* End of Fix

        CALL AT.ISO.FMT.BAL.RTN(R.ACCT,Y.WORK.BAL,Y.AVAIL.BAL,BALANCE.FORMATTED)

        BALANCE.FORMATTED.LEN=LEN(BALANCE.FORMATTED)
        BALANCE.FORMATTED.LEN.FMT=FMT(BALANCE.FORMATTED.LEN,'R%3')
*GOSUB GET.UNIQUE.ID
        Y.UNIQUE.ID=''
        IF ENQ.ERROR.COM EQ '' THEN

            IF ISO.RESP NE 00 THEN
                Y.UNIQUE.ID = ''

            END ELSE
                GOSUB GET.UNIQUE.ID
                R.ACCOUNT=R.ACCT
                CALL V.FT.UPD.ENQ.ATM.KEY.ID
            END

            Y.ID.LIST<-1> = 'BALANCE:1:1=':BALANCE.FORMATTED:',':'UNIQUE.TXN.CODE:1:1=':Y.UNIQUE.ID:',':'Y.ISO.RESPONSE:1:1=':ISO.RESP:',':'Y.ACCT.NO:1:1=':Y.ACCT.NO:','

            IF Y.ERR THEN
                Y.ID.LIST:=',':Y.ERR
            END

        END ELSE

            BALANCE.FORMATTED = '00000000000000000000000'
* Y.UNIQUE.ID = '111111'
            ETEXT1=ENQ.ERROR.COM
            ETEXT=ENQ.ERROR.COM
            CALL EB.GET.ERROR.MESSAGE(ETEXT1)
            ENQ.ERROR.COM=ETEXT1<1,1>
            CALL REDO.GET.ISO.RESP(ENQ.ERROR.COM)

            ISO.RESP=ENQ.ERROR.COM<1>
            ENQ.ERROR.COM=ENQ.ERROR.COM<2>
            Y.ID.LIST<-1> = 'BALANCE:1:1=':BALANCE.FORMATTED:',':'UNIQUE.TXN.CODE:1:1=':Y.UNIQUE.ID:',':'Y.ISO.RESPONSE:1:1=':ISO.RESP:',':'Y.ISO.ERROR:1:1=':
            ETEXT=''
        END
    END ELSE

        BALANCE.FORMATTED = '00000000000000000000000'
*   Y.UNIQUE.ID = '111111'
        ENQ.ERROR.COM='EB-INVALD.DC.NUMBER'
        ETEXT1=ENQ.ERROR.COM
        ETEXT=ENQ.ERROR.COM
        CALL EB.GET.ERROR.MESSAGE(ETEXT1)
        ENQ.ERROR.COM=ETEXT1<1,1>
        CALL REDO.GET.ISO.RESP(ENQ.ERROR.COM)

        ISO.RESP=ENQ.ERROR.COM<1>
        ENQ.ERROR.COM=ENQ.ERROR.COM<2>

        Y.ID.LIST<-1> = 'BALANCE:1:1=':BALANCE.FORMATTED:',':'UNIQUE.TXN.CODE:1:1=':Y.UNIQUE.ID:',':'Y.ISO.RESPONSE:1:1=':ISO.RESP
        ETEXT=''
    END

    RETURN          ;*From process

*-------------------------------------------------------------------*
GET.UNIQUE.ID:
*------------*

    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    CHANGE '.' TO '' IN UNIQUE.TIME
    LEN.UNIQUE.TIME = LEN(UNIQUE.TIME) -6
    Y.UNIQUE.ID = UNIQUE.TIME[LEN.UNIQUE.TIME,6]

    RETURN          ;*From GET.UNIQUE.ID

*-------------------------------------------------------------------------*
END
