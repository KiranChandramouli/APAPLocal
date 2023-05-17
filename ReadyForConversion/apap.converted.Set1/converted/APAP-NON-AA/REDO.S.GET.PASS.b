SUBROUTINE REDO.S.GET.PASS(USER.PASS)
*-----------------------------------------------------------------------------
* Program Description
* Rutina que recupera el password y lo desencripta
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT JBC.h
    $INSERT I_F.REDO.AT.USER.PASS

*-----------------------------------------------------------------------------

    GOSUB INITIALISE

RETURN

*-----------------------------------------------------------------------------
INITIALISE:

    F.REDO.AT.USER.PASS = ''
    FN.REDO.AT.USER.PASS = 'F.REDO.AT.USER.PASS'
    R.REDO.AT.USER.PASS = ""
    SIGNON = USER.PASS
    CALL OPF (FN.REDO.AT.USER.PASS,F.REDO.AT.USER.PASS)
    CALL F.READ(FN.REDO.AT.USER.PASS,SIGNON,R.REDO.AT.USER.PASS,F.REDO.AT.USER.PASS,"")
    IF NOT(R.REDO.AT.USER.PASS) THEN
        USER.PASS = ""
        RETURN
    END
*  MPASS = FIELD( R.REDO.AT.USER.PASS<1> , @VM , 1)
*  CLAVE = FIELD( R.REDO.AT.USER.PASS<1> , @VM , 2)
* Tus Start
    MPASS = FIELD(R.REDO.AT.USER.PASS<AT.US.USER.PASS> , @VM , 1)
    CLAVE = FIELD(R.REDO.AT.USER.PASS<AT.US.USER.PASS> , @VM , 2)
* Tus End
    USER.PASS = DECRYPT(MPASS,CLAVE,JBASE_CRYPT_DES)
*PRINT R.REDO.AT.USER.PASS<1>:'_':MPASS:'_':CLAVE:'_':USER.PASS
RETURN

*-----------------------------------------------------------------------------
*
END
