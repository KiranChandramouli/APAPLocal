SUBROUTINE REDO.E.NOF.ACCT.COMP.NAU(ENQ.DATA)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.E.NOF.ACCT.COMP.NAU
*-------------------------------------------------------------------------
* Description: This routine is a Nofile Routine for the Account application
*-------------------------------------------------------------------------
* Linked with   : REDO.E.ACCT.NAU
* In parameter  : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 16-10-11            ODR-2011-08-0055
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ACCT.EXCE.RBHP

    GOSUB OPEN.PROCESS
    GOSUB PROCESS

RETURN

OPEN.PROCESS:
*------------



    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT$NAU='F.ACCOUNT$NAU'
    F.ACCOUNT$NAU=''

    CALL OPF( FN.ACCOUNT$NAU,F.ACCOUNT$NAU)

    FN.REDO.ACCT.EXCE.RBHP='F.REDO.ACCT.EXCE.RBHP'
    F.REDO.ACCT.EXCE.RBHP=''

    CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)

RETURN

PROCESS:
*-------

    LOCATE 'ACCOUNT.NO' IN D.FIELDS<1> SETTING ACCT.POS THEN
        ACCOUNT.NO=D.RANGE.AND.VALUE<ACCT.POS>
    END

    IF ACCOUNT.NO EQ '' OR ACCOUNT.NO NE '' THEN

        GOSUB ACCT.RECORDS

    END

RETURN

ACCT.RECORDS:
*-----------

    R.REDO.ACCT.EXCE.RBHP=''
    ERR.EXCE.RBHP=''

    CALL F.READ(FN.REDO.ACCT.EXCE.RBHP,ID.COMPANY,R.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP,ERR.EXCE.RBHP)
    IF R.REDO.ACCT.EXCE.RBHP NE '' THEN

        Y.ACCT.CNT=DCOUNT(R.REDO.ACCT.EXCE.RBHP,@FM)

        Y.CNT=0
        LOOP
            Y.CNT+=1
        WHILE Y.CNT LE Y.ACCT.CNT

            Y.ACCT.ID=FIELD(R.REDO.ACCT.EXCE.RBHP,@FM,Y.CNT)

            GOSUB READ.ACCT.NAU

            IF R.NAU.ACCOUNT NE '' THEN

                ENQ.DATA<-1>=Y.ACCT.ID:"#":Y.CUS.ID:"#":Y.INPUT.USER:"#":Y.BASE.COMP

            END

        REPEAT

    END

RETURN

READ.ACCT.NAU:
*-------------

    Y.CUS.ID=''
    Y.AU.INPUTTER=''
    Y.INPUT.USER=''
    Y.BASE.COMP=''

    CALL F.READ(FN.ACCOUNT$NAU,Y.ACCT.ID,R.NAU.ACCOUNT,F.ACCOUNT$NAU,COMP.ERR)

    Y.CUS.ID=R.NAU.ACCOUNT<AC.CUSTOMER>
    Y.AU.INPUTTER=R.NAU.ACCOUNT<AC.INPUTTER>
    Y.INPUT.USER=FIELD(Y.AU.INPUTTER,'_',2)
    Y.BASE.COMP=R.NAU.ACCOUNT<AC.CO.CODE>

RETURN

END
