* @ValidationCode : MjoyNTU0MTQxMTE6Q3AxMjUyOjE2ODE3MzM1OTI5OTI6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 17:43:12
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
SUBROUTINE REDO.V.VAL.SOLICIT.STK.ENTRY
*-----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.V.VAL.SOLICIT.STK.ENTRY
*----------------------------------------------------------------------
*DESCRIPTION: The following fields in REDO.H.SOLICITUD.CK application,
* have to be brought automatically from STOCK.ENTRY application,
* once the field FICHA.IMPR is completed with the corresponding STOCK.ENTRY id
* IN PARAMETER:NONE
* OUT PARAMETER:NONE
* LINKED WITH:REDO.H.SOLICITUD.CK
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                       REFERENCE         DESCRIPTION
*17.02.2009     S SUDHARSANAN             ODR-2009-12-0275  INITIAL CREATION
*----------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                     VM TO @VM,SM TO @SM,++ to +=1
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.REDO.H.SOLICITUD.CK
    $INSERT I_EB.EXTERNAL.COMMON
    GOSUB INIT
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.STOCK.ENTRY='F.STOCK.ENTRY'
    F.STOCK.ENTRY=''
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)
    GOSUB LOCREF
RETURN
*--------------------------------------------------------------------------
LOCREF:
*---------------------------------------------------------------------------

    LOC.REF.APPLICATION="STOCK.ENTRY"
    LOC.REF.FIELDS='L.STE.MODCQ':@VM:'L.STE.COMMTAL':@VM:'L.AC.ALPH.AC.NO':@VM:'L.AC.STD.ACC.NO':@VM:'L.AC.CHEK.DIGIT':@VM:'L.STE.NAMEADD':@VM:'L.STE.DOCUMENTO'
    LOC.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.POS)
    MOD.CQ.POS=LOC.POS<1,1>
    COM.TAL.POS=LOC.POS<1,2>
    ALPH.POS=LOC.POS<1,3>
    NUM.POS=LOC.POS<1,4>
    CHEK.POS=LOC.POS<1,5>
    NAME.ADD.POS=LOC.POS<1,6>
    STE.DOC.POS=LOC.POS<1,7>
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*Default the field values to REDO.H.SOLICITUD.CK table

    ACC.ID=R.NEW(REDO.H.SOL.ACCOUNT)
    IF EB.EXTERNAL$CHANNEL EQ 'INTERNET' THEN
        STK.ENT.ID = R.NEW(REDO.H.SOL.FICHA.IMPR)
    END ELSE
        STK.ENT.ID=COMI
    END


    CALL F.READ(FN.STOCK.ENTRY,STK.ENT.ID,R.STK.ENT,F.STOCK.ENTRY,STK.ERR)
    R.NEW(REDO.H.SOL.FICHA.IMPR)=STK.ENT.ID
    R.NEW(REDO.H.SOL.CHEQUE.TYPE)=R.STK.ENT<STO.ENT.CHEQUE.TYPE>
    R.NEW(REDO.H.SOL.MODELO.CK)=R.STK.ENT<STO.ENT.LOCAL.REF,MOD.CQ.POS>
    R.NEW(REDO.H.SOL.COSTO.CK)<1,1>=R.STK.ENT<STO.ENT.LOCAL.REF,COM.TAL.POS>
    NAME.ADD.CNT=DCOUNT(R.STK.ENT<STO.ENT.LOCAL.REF,NAME.ADD.POS>,@SM)
    NAME.ADD=1
    LOOP
    WHILE NAME.ADD LE NAME.ADD.CNT
        R.NEW(REDO.H.SOL.NAME.ADDR)<1,NAME.ADD>=R.STK.ENT<STO.ENT.LOCAL.REF,NAME.ADD.POS,NAME.ADD>
        NAME.ADD += 1
    REPEAT
    R.NEW(REDO.H.SOL.DOCNO.CL)=R.STK.ENT<STO.ENT.LOCAL.REF,STE.DOC.POS>
    R.NEW(REDO.H.SOL.NO.CTA.ALFAN)=R.STK.ENT<STO.ENT.LOCAL.REF,ALPH.POS>
    R.NEW(REDO.H.SOL.NO.CTA.NUM)=R.STK.ENT<STO.ENT.LOCAL.REF,NUM.POS>
    R.NEW(REDO.H.SOL.CHECK.DIGIT)=R.STK.ENT<STO.ENT.LOCAL.REF,CHEK.POS>
    R.NEW(REDO.H.SOL.SERIES.ID)=R.NEW(REDO.H.SOL.CHEQUE.TYPE):"*1*":ACC.ID

RETURN
*--------------------------------------------------------------------------------------
END
