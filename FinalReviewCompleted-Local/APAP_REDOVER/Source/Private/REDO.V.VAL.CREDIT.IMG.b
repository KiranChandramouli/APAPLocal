* @ValidationCode : MjoxOTg2NDYyODc5OkNwMTI1MjoxNjgzMDEwNzg0MjU5OklUU1M6LTE6LTE6MTg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 12:29:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 185
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.CREDIT.IMG
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.CREDIT
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it in R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536    Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
* 26-JUN-2011        Prabhu N       PACS00061657        modified to support error message
*-------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*13-04-2023              Samaran T                R22 Manual Code conversion                       Call Routine Format Modified
*--------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.SUNNEL.PARAMETER
    IF VAL.TEXT EQ '' THEN
        GOSUB INIT
        GOSUB PROCESS
    END
RETURN
*---------
INIT:
*--------
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.SUNNEL.PARAMETER='F.REDO.SUNNEL.PARAMETER'
    F.REDO.SUNNEL.PARAMETER=''

    LREF.APP='TELLER':@FM:'CUSTOMER'
    LREF.FIELDS='L.TT.CUS.IMAGE':@VM:'L.TT.CLIENT.COD':@VM:'L.TT.AC.STATUS':@VM:'L.TT.CR.CARD.NO':@FM:'L.CU.CIDENT'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    VAR.CUS.IMAGE.POS=LREF.POS<1,1>
    VAR.CUSTOMER     =LREF.POS<1,2>
    Y.AC.ST.POS      =LREF.POS<1,3>
    Y.CARD.POS       =LREF.POS<1,4>
    LREF.CUS.POS     =LREF.POS<2>
RETURN

*-----------
PROCESS:
*------------
    Y.PREV.CARD.NO=R.NEW.LAST(TT.TE.LOCAL.REF)<1,Y.CARD.POS>
    Y.NEW.CARD.NO =COMI
    IF Y.PREV.CARD.NO EQ Y.NEW.CARD.NO THEN
        RETURN
    END
    Y.ARRAY='BUSCAR_TARJETA_CUENTA.1'
    CALL APAP.REDOVER.redoVWrapSunnel(Y.ARRAY)    ;*R22 MANUAL CODE CONVERSION

    VAR.CUSTOMER=R.NEW(TT.TE.LOCAL.REF)<1,VAR.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,VAR.CUSTOMER,R.CUSTOMER,F.CUSTOMER,ERR)
    Y.CARD.ACCT.ST=R.NEW(TT.TE.LOCAL.REF)<1,Y.AC.ST.POS>
    VAR.CEDULA='Padrone$':R.CUSTOMER<EB.CUS.LOCAL.REF><1,LREF.CUS.POS>
    CALLJ "com.padrone.ws.util.MainClass","callPadrone",VAR.CEDULA SETTING RET.CEDULA ON ERROR
    END
    CHANGE '#' TO @FM IN RET.CEDULA
    R.NEW(TT.TE.LOCAL.REF)<1,VAR.CUS.IMAGE.POS>=RET.CEDULA<7>
    COMI=COMI[1,6]:'******':COMI[13,4]

    CALL CACHE.READ(FN.REDO.SUNNEL.PARAMETER,'SYSTEM',R.REDO.SUNNEL.PARAMETER,ERR)
    Y.STATUS<2>=R.REDO.SUNNEL.PARAMETER<SP.CLOSED.STATUS>

    IF Y.CARD.ACCT.ST EQ Y.STATUS<2> THEN
        ETEXT="EB-REDO.CARD.CLOSED"
        CALL STORE.END.ERROR
    END
RETURN
