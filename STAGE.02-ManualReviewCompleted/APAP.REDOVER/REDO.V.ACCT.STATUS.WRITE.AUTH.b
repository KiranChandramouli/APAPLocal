* @ValidationCode : MjoxNTAwMDAwODY0OkNwMTI1MjoxNjgwNzczMTA4NTcyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:55:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.ACCT.STATUS.WRITE.AUTH
* ----------------------------------------------------------------------------------------------
* Company Name     : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By     : Temenos India Pvt Ltd
* Author           : Gopala Krishnan R
* Development Id   : PACS00682620_2660842
* Date             : 17-JUL-2018
*----------------------------------------------------------------------------------------------
* Subroutine Type  : Auth Routine
* Attached to      : VERSION > TELLER,REDO.ACCOUNT.CLOSURE.ML
*
*
* Attached As      : Auth Routine
* ----------------------------------------------------------------------------------------------
* Primary Purpose  : This is an AUTHORISATION routine to update ACCOUNT.STATUS on ACCOUNT.CLOSURE application.
*
* ----------------------------------------------------------------------------------------------
* ARGS -(Input)    : N/A
* ARGS -(Output)   : N/A
* ----------------------------------------------------------------------------------------------
* Modification History:
* ---------------------
* Modification Ref :
* Modification Date:
* Modified by      :
* Modifi. Descript :
*----------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*06-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*06-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT.CLOSURE

    GOSUB INIT
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------


    FN.ACCOUNT.CLOSURE ='F.ACCOUNT.CLOSURE'
    F.ACCOUNT.CLOSURE =''
    CALL OPF(FN.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE)

    Y.APPL.1 = 'ACCOUNT.CLOSURE'
    Y.FIELD.1 = 'L.TT.AC.STATUS'
    Y.POS.1 = ''
    CALL GET.LOC.REF(Y.APPL.1,Y.FIELD.1,Y.POS.1)

    Y.APPL.2 = 'TELLER'
    Y.FIELD.2 = 'L.TT.AZ.ACC.REF'
    Y.POS.2 = ''
    CALL GET.LOC.REF(Y.APPL.2,Y.FIELD.2,Y.POS.2)

RETURN

*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    Y.ACCT = R.NEW(TT.TE.LOCAL.REF)<1,Y.POS.2>
    CALL F.READ(FN.ACCOUNT.CLOSURE,Y.ACCT,R.ACCOUNT.CLOSURE,F.ACCOUNT.CLOSURE,ACCOUNT.CLOSURE.ERR)
    ACCT.STATUS = R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,Y.POS.1>

    IF ACCT.STATUS EQ "" THEN
        ACCT.STATUS = "CLOSED"
        R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,Y.POS.1> = ACCT.STATUS
        CALL F.WRITE(FN.ACCOUNT.CLOSURE,Y.ACCT,R.ACCOUNT.CLOSURE)
    END

RETURN

END
