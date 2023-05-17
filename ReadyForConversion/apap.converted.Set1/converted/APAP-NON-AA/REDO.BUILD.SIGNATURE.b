SUBROUTINE REDO.BUILD.SIGNATURE(ENQ.DATA)
*---------------------------------------------------
*Description: This routine is to  Build routine to pass the acc no. & cus id as incoming arg.
*---------------------------------------------------
* Input  Arg: ENQ.DATA
* oUTPUT Arg: ENQ.DATA
* Deals with: REDO.IM.CONSULTA.FIRMAS
*---------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    LOCATE 'IMAGE.REFERENCE' IN ENQ.DATA<2,1> SETTING POS1 THEN
        Y.AC.ID = ENQ.DATA<4,POS1>
    END

    IF Y.AC.ID THEN
        CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        IF R.ACCOUNT THEN
            ENQ.DATA<4,POS1> = ENQ.DATA<4,POS1>:' ':R.ACCOUNT<AC.CUSTOMER>
        END
    END


RETURN
END
