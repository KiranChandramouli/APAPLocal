SUBROUTINE E.REDO.BUILD.STOP.OT.COMREC(ENQ.DATA)
*------------------------------------------------------------------------------------------------
* Developed By : TAM (Marimuthus)
* Description  : This is build routine. It is used to list the exception file in particular branch
* Reference    : PACS00247789
*------------------------------------------------------------------------------------------------
* Modification History:
*------------------
*   Date               who           Reference            Description
* 24-MAR-2017         simbu          PACS00574793       Account number selection issue
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY
    $INSERT I_ENQUIRY.COMMON
    FN.REDO.ACCT.EXCE.RBHP = 'F.REDO.ACCT.EXCE.RBHP'
    F.REDO.ACCT.EXCE.RBHP = ''
    CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)

    Y.FILE.NAME = R.ENQ<ENQ.FILE.NAME>
    Y.FILE.NAME = FIELD(Y.FILE.NAME,'$',1)

    Y.ID = Y.FILE.NAME:'-':ID.COMPANY
    GOSUB PRE.PROCESS

    IF R.REDO.ACCT.EXCE.RBHP THEN

        BEGIN CASE

            CASE (Y.FILE.NAME EQ 'ACCOUNT') OR (Y.FILE.NAME EQ 'ACCOUNT.STATEMENT') OR (Y.FILE.NAME EQ 'ACCT.CAPITALISATION')
                GOSUB PROCESS.AC

            CASE Y.FILE.NAME EQ 'AZ.ACCOUNT'
                GOSUB PROCESS.AC

            CASE (Y.FILE.NAME EQ 'ACCOUNT.CREDIT.INT') OR (Y.FILE.NAME EQ 'ACCOUNT.DEBIT.INT')
                GOSUB PROCESS.ACI
            CASE Y.FILE.NAME EQ 'AC.LOCKED.EVENTS'
                GOSUB CHECK.ID.VALUE

            CASE 1
                GOSUB PROCESS.AC

        END CASE
    END ELSE
        ENQ.DATA<2,1> = '@ID'
        ENQ.DATA<3,1> = 'EQ'
        ENQ.DATA<4,1>  = 'ZZZZZ'
    END

RETURN

*----------*
PRE.PROCESS:
*----------*

    SEL.RBHP.LIST = '' ; ERR.RBHP.CUS = '' ; R.REDO.ACCT.EXCE.RBHP = ''
    SEL.CUS.CMD = 'SELECT ':FN.REDO.ACCT.EXCE.RBHP:' WITH @ID LIKE ':Y.ID:'...'
    CALL EB.READLIST(SEL.CUS.CMD,SEL.RBHP.LIST,'',NO.OF.REC,ERR.RBHP.CUS)

    IF SEL.RBHP.LIST THEN
        LOOP
            REMOVE Y.RBHP.ID FROM SEL.RBHP.LIST SETTING RBHP.POS
        WHILE Y.RBHP.ID:RBHP.POS
            R.REDO.ACCT.EXCE.RBHP<-1> = FIELD(Y.RBHP.ID,'-',3)
        REPEAT
    END

RETURN

*----------*
PROCESS.ACI:
*----------*

    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING POS1 THEN
        Y.VAL = ENQ.DATA<4,POS1>
        FINDSTR Y.VAL IN R.REDO.ACCT.EXCE.RBHP SETTING POS.L ELSE
            ENQ.DATA<4,POS1> = 'ZZZZZ'
        END
    END ELSE
        R.REDO.ACCT.EXCE.RBHP = CHANGE(R.REDO.ACCT.EXCE.RBHP,@FM,@SM)
        ENQ.DATA<2,-1> = "@ID"
        ENQ.DATA<3,-1> = "EQ"
        ENQ.DATA<4,-1> = R.REDO.ACCT.EXCE.RBHP
    END

RETURN

*---------*
PROCESS.AC:
*---------*

    LOCATE 'ACCOUNT.NUMBER' IN ENQ.DATA<2,1> SETTING POS1 THEN
        ENQ.DATA<2,POS1> = "@ID"
        Y.VAL = ENQ.DATA<4,POS1>
        LOCATE Y.VAL IN R.REDO.ACCT.EXCE.RBHP SETTING POS.L ELSE
            ENQ.DATA<4,POS1> = 'ZZZZZ'
        END
    END ELSE
        GOSUB CHECK.ID.VALUE
    END

RETURN

*-------------*
CHECK.ID.VALUE:
*-------------*

    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING POS1 THEN
        Y.VAL = ENQ.DATA<4,POS1>
        LOCATE Y.VAL IN R.REDO.ACCT.EXCE.RBHP SETTING POS.L ELSE
            ENQ.DATA<4,POS1> = 'ZZZZZ'
        END
    END ELSE
        LOCATE 'ACCOUNT.NUMBER' IN ENQ.DATA<2,1> SETTING POS1 ELSE
            R.REDO.ACCT.EXCE.RBHP = CHANGE(R.REDO.ACCT.EXCE.RBHP,@FM,@SM)
            ENQ.DATA<2,-1> = "@ID"
            ENQ.DATA<3,-1> = "EQ"
            ENQ.DATA<4,-1> = R.REDO.ACCT.EXCE.RBHP
        END
    END

RETURN
*----------------------------------------------------------------------------------------------------------------------
END
