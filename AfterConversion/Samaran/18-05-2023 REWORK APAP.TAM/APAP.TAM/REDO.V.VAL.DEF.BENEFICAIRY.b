* @ValidationCode : Mjo2MjA3MDA3MjY6Q3AxMjUyOjE2ODQ0MDg3MjYzNDY6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 May 2023 16:48:46
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.DEF.BENEFICAIRY
*---------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.V.VAL.DEF.BENEFICAIRY
* ODR NO      : ODR-2009-12-0285
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine attached to L.FT.BEN.LIST
* field in below versions,
* FUNDS.TRANSFER,CHQ.TAX
* FUNDS.TRANSFER,CHQ.OTHERS
* FUNDS.TRANSFER,CHQ.NO.TAX
* TELLER,CHQ.NO.TAX
* TELLER,CHQ.TAX
* FUNDS.TRANSFER,MGR.CHQ.NO.TAX
* FUNDS.TRANSFER,MGRUSD.CHQ.NO.TAX
* TELLER,MGR.CHQ.NOTAX


*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*19.02.2010  H GANESH     ODR-2009-12-0285  INITIAL CREATION
*06.09.2011  R GANESH     PACS00094454      Modified according to Final Version
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.MANAGER.CHQ.PARAM
    $INSERT I_F.REDO.H.ADMIN.CHEQUES
    $INSERT I_F.EB.LOOKUP

    IF PGM.VERSION EQ ',MGR.CHQ.NO.TAX' THEN
        GOSUB INIT
        GOSUB PROCESS.MGR
    END

    GOSUB INIT
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------
INIT:
*----

    FN.REDO.MANAGER.CHQ.PARAM='F.REDO.MANAGER.CHQ.PARAM'
    F.REDO.MANAGER.CHQ.PARAM=''
    FN.REDO.H.ADMIN.CHEQUES='F.REDO.H.ADMIN.CHEQUES'
    F.REDO.H.ADMIN.CHEQUES=''
    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''

    CALL OPF(FN.REDO.MANAGER.CHQ.PARAM,F.REDO.MANAGER.CHQ.PARAM)
    CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    CALL CACHE.READ(FN.REDO.MANAGER.CHQ.PARAM,'SYSTEM',R.REDO.MANAGER.CHQ.PARAM,ERR.RMCP)

RETURN
*----------------------------------------------------------------------
PROCESS:

    Y.BEN.LIST=COMI

    LOC.REF.APPLICATION="TELLER":@FM:"FUNDS.TRANSFER" ;*R22 AUTO CONVERSION
    LOC.REF.FIELDS='L.TT.BEN.LIST':@VM:'L.TT.BENEFICIAR':@FM:'L.TT.BEN.LIST':@VM:'BENEFIC.NAME' ;*R22 AUTO CONVERSION
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.TT.BEN.LIST   = LOC.REF.POS<1,1>
    POS.L.TT.BENEFICIAR = LOC.REF.POS<1,2>
    POS.FT.BEN.LIST     = LOC.REF.POS<2,1>
    POS.FT.BENEF.NAME   = LOC.REF.POS<2,2>

    IF Y.BEN.LIST EQ '' THEN
        ETEXT = "EB-INPUT.MISSING"
        CALL STORE.END.ERROR
    END ELSE
        GOSUB GET.LOOKUP.DESC
    END


    IF APPLICATION EQ 'TELLER' THEN
        R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.BENEFICIAR,1> = Y.EBLOOK.DESC
    END

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        R.NEW(FT.LOCAL.REF)<1,POS.FT.BENEF.NAME,1> = Y.EBLOOK.DESC
    END

* IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
*     Y.BENEFICIARY=COMI
*     IF R.NEW(FT.BEN.CUSTOMER) EQ '' THEN
*         IF PGM.VERSION NE ',MGR.CHQ.NO.TAX' AND PGM.VERSION NE ',MGRUSD.CHQ.NO.TAX' THEN
*             R.NEW(FT.BEN.CUSTOMER)=Y.BENEFICIARY
*         END ELSE
*             IF R.NEW(FT.DEBIT.THEIR.REF) EQ '' THEN
*                 R.NEW(FT.DEBIT.THEIR.REF)=Y.BENEFICIARY[1,16]
*             END
*         END
*     END
* END

RETURN

*---------------
GET.LOOKUP.DESC:
*---------------

    R.EB.LOOKUP = '' ; ERR.RMCP = ''
    Y.TEMP = "L.FT.BEN.LIST*":COMI
    CALL F.READ(FN.EB.LOOKUP,Y.TEMP,R.EB.LOOKUP,F.EB.LOOKUP,ERR.RMCP)
    IF R.EB.LOOKUP NE '' THEN
        Y.EBLOOK.DESC = ''
        Y.EBLOOK.DESC = R.EB.LOOKUP<EB.LU.DESCRIPTION,LNGG>
        IF NOT(Y.EBLOOK.DESC) THEN
            Y.EBLOOK.DESC = R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
        END
    END

RETURN


*----------------------------------------------------------------------
PROCESS.MGR:
*-----------

    LOCATE COMI IN R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT,1> SETTING POS1 THEN

        Y.ITEM.CODE=R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ITEM.CODE,POS1>

    END

    SEL.CMD='SSELECT ':FN.REDO.H.ADMIN.CHEQUES:' WITH ITEM.CODE EQ ':Y.ITEM.CODE:' AND BRANCH.DEPT EQ ':ID.COMPANY:' AND STATUS EQ AVAILABLE BY SERIAL.NO'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    Y.NEXT.AVAILABLE.ID=SEL.LIST<1,1>
    R.NEW(FT.CREDIT.THEIR.REF)=Y.NEXT.AVAILABLE.ID

RETURN

*-----------------------------------------------------------------------
END
