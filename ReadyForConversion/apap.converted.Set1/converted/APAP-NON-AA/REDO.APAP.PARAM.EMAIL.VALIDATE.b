SUBROUTINE REDO.APAP.PARAM.EMAIL.VALIDATE
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: .VALIDATE routine
*------------
*DESCRIPTION:
*------------
* This is the .VALIDATE routine to check whther the path entered by the user is valid or
* not
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 23-NOV-2010   A.SabariKumar     ODR-2010-07-0075       Initial Creation
*---------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.PARAM.EMAIL

    Y.IN.PATH = R.NEW(REDO.PRM.MAIL.IN.PATH.MAIL)   ;* Inpath of a file
    Y.ERR.PATH =R.NEW(REDO.PRM.MAIL.ERR.PATH.MAIL)  ;* Error path of the file
    IF Y.IN.PATH THEN
        OPENPATH Y.IN.PATH TO Y.IN.PATH.PTR ELSE
            ETEXT="EB-INVALID.PATH"
            AF=REDO.PRM.MAIL.IN.PATH.MAIL
        END
    END
    IF ETEXT THEN
        CALL STORE.END.ERROR      ;*Calling the core routine
        RETURN
    END

    IF Y.ERR.PATH THEN
        OPENPATH Y.ERR.PATH TO Y.ERR.PATH.PTR ELSE
            ETEXT="EB-INVALID.PATH"
            AF=REDO.PRM.MAIL.ERR.PATH.MAIL
        END
    END
    IF ETEXT THEN
        CALL STORE.END.ERROR      ;*Calling the core routine
        RETURN
    END

RETURN
*---------------------------------------------------------------------------
END
