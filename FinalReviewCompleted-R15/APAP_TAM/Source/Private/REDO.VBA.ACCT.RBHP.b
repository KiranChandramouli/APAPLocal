* @ValidationCode : Mjo3MjQyNTcyODE6Q3AxMjUyOjE2ODQ4NDIxNDg5NTE6SVRTUzotMTotMTo2Njc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:28
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 667
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VBA.ACCT.RBHP
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.VBA.ACCT.RBHP
*-------------------------------------------------------------------------
* Description: This routine is a After auth routine for the Version ACCOUNT,RBHP
*-------------------------------------------------------------------------
* Linked with   : VERSION>ACCOUNT,RBHP
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 16-10-11            ODR-2011-08-0055
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           F.READ TO CACHE.READ
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.ACCT.EXCE.RBHP
    $INSERT I_F.REDO.ACCT.COMP.EXCE

    GOSUB OPEN.PROCESS
    GOSUB PROCESS

RETURN

OPEN.PROCESS:
*------------

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''

    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.ACCT.EXCE.RBHP='F.REDO.ACCT.EXCE.RBHP'
    F.REDO.ACCT.EXCE.RBHP=''

    CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)

    FN.REDO.ACCT.COMP.EXCE='F.REDO.ACCT.COMP.EXCE'
    F.REDO.ACCT.COMP.EXCE=''

    CALL OPF(FN.REDO.ACCT.COMP.EXCE,F.REDO.ACCT.COMP.EXCE)

    FN.USER='F.USER'
    F.USER=''

    CALL OPF(FN.USER,F.USER)

RETURN

PROCESS:
*-------

    Y.ACCT.NO=ID.NEW

    Y.CO.CODE=R.NEW(AC.CO.CODE)

    GOSUB READ.USER

    IF Y.USER.COMP.CODE NE ID.COMPANY THEN

        GOSUB UPD.CONCAT

        GOSUB UPD.COMP.EXCEP

    END

RETURN


UPD.CONCAT:
*---------

    ERR.EXCE=''
    R.REDO.ACCT.EXCE.RBHP=''

    CALL F.READ(FN.REDO.ACCT.EXCE.RBHP,Y.USER.COMP.CODE,R.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP,ERR.EXCE)
    IF R.REDO.ACCT.EXCE.RBHP NE '' THEN

        LOCATE Y.ACCT.NO IN R.REDO.ACCT.EXCE.RBHP SETTING Y.AC.EX.POS THEN

            DEL R.REDO.ACCT.EXCE.RBHP<Y.AC.EX.POS>

            CALL F.WRITE(FN.REDO.ACCT.EXCE.RBHP,Y.USER.COMP.CODE,R.REDO.ACCT.EXCE.RBHP)

        END

    END

RETURN

UPD.COMP.EXCEP:
*-------------


    ERR.EX.COMP=''
    R.REDO.ACCT.COMP.EXCE=''

*CALL F.READ(FN.REDO.ACCT.COMP.EXCE,ID.COMPANY,R.REDO.ACCT.COMP.EXCE,F.REDO.ACCT.COMP.EXCE,ERR.EX.COMP) ;*Tus Start
    CALL CACHE.READ(FN.REDO.ACCT.COMP.EXCE,ID.COMPANY,R.REDO.ACCT.COMP.EXCE,ERR.EX.COMP) ;*Tus End
    IF R.REDO.ACCT.COMP.EXCE NE '' THEN

        LOCATE Y.ACCT.NO IN R.REDO.ACCT.COMP.EXCE SETTING AC.COMP.EXE THEN

            DEL R.REDO.ACCT.COMP.EXCE<AC.COMP.EXE>

            CALL F.WRITE(FN.REDO.ACCT.COMP.EXCE,ID.COMPANY,R.REDO.ACCT.COMP.EXCE)

        END

    END

RETURN


READ.USER:
*---------

    R.OP.USER=''
    ERR.USR=''

    CALL CACHE.READ(FN.USER, OPERATOR, R.OP.USER, ERR.USR)

    Y.USER.COMP.CODE=R.OP.USER<EB.USE.COMPANY.CODE,1>

RETURN


END
