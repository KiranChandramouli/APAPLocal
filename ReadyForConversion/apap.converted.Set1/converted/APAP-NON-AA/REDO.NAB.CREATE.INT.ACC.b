SUBROUTINE REDO.NAB.CREATE.INT.ACC(Y.LOAN.ACC.CODE,Y.INT.ACC,Y.RET.INT.ACC)
*-----------------------------------------------------
* Description: This routine is to generate the internal account for NAB accounting
* Based on loan's branch
*-----------------------------------------------------
* Input   Arg: Y.LOAN.ACC.CODE,Y.INT.ACC
* Output  Arg: Y.RET.INT.ACC
*-----------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY


    Y.RET.INT.ACC = ''
    IF Y.LOAN.ACC.CODE AND Y.INT.ACC ELSE ;* Exit from routine if incoming arg missing
        RETURN
    END

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------
OPENFILES:
*-----------------------------------------------------
    FN.COMPANY = 'F.COMPANY'
    F.COMPANY  = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------

    CALL CACHE.READ(FN.COMPANY,Y.LOAN.ACC.CODE,R.COMP.REC,COM.ERR)
    IF R.COMP.REC THEN
        Y.COMP.DIV.CODE = R.COMP.REC<EB.COM.SUB.DIVISION.CODE>
        Y.INT.ACC.CO = Y.INT.ACC[LEN(Y.INT.ACC)-3,4]
        IF Y.COMP.DIV.CODE EQ Y.INT.ACC.CO THEN
            Y.RET.INT.ACC = Y.INT.ACC
        END ELSE
            Y.RET.INT.ACC = Y.INT.ACC[1,LEN(Y.INT.ACC)-4]:Y.COMP.DIV.CODE
            CALL F.READ(FN.ACCOUNT,Y.RET.INT.ACC,R.ACC,F.ACCOUNT,ACC.ERR)

            IF R.ACC ELSE
                CALL INT.ACC.OPEN (Y.RET.INT.ACC,PRETURN.CODE)
            END

        END
    END

RETURN
END
