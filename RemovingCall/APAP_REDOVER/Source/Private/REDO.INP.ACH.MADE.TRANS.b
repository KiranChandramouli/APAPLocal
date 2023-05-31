* @ValidationCode : MjoxODM5MzE5MDI2OkNwMTI1MjoxNjgyNDEyMzI5ODM3OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.ACH.MADE.TRANS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.INP.ACH.MADE.TRANS
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This is input routine will make the changes into the tempalte REDO.ADMIN.CHEQUE.DETAILS
* In parameter  : none
* out parameter : none
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 13-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 VM to @VM
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.ACH.TRANSFER.DETAILS
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB PROCESS
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    FN.REDO.ACH.TRANSFER.DETAILS = 'F.REDO.ACH.TRANSFER.DETAILS'
    F.REDO.ACH.TRANSFER.DETAILS = ''
    CALL OPF(FN.REDO.ACH.TRANSFER.DETAILS,F.REDO.ACH.TRANSFER.DETAILS)


    Y.APPLN = 'FUNDS.TRANSFER'
    Y.FIELDS = 'L.FT.ACH.B.NAM':@VM:'L.FT.ACH.B.ACC':@VM:'L.FTST.ACH.PART'
    CALL MULTI.GET.LOC.REF(Y.APPLN,Y.FIELDS,POS)
    Y.BEN.POS = POS<1,1>
    Y.BEN.ACC.POS = POS<1,2>
    Y.BEN.BNK.POS = POS<1,3>
    Y.BEN.VAL = R.NEW(FT.LOCAL.REF)<1,Y.BEN.POS>
    Y.BEN.ACC = R.NEW(FT.LOCAL.REF)<1,Y.BEN.ACC.POS>
    Y.BEN.BNK = R.NEW(FT.LOCAL.REF)<1,Y.BEN.BNK.POS>

    SEL.CMD = 'SELECT ':FN.REDO.ACH.TRANSFER.DETAILS:' WITH TRANS.ACH EQ "NO" AND BENEFICIARY EQ ':Y.BEN.VAL:' AND BENEFICIARY.ACC EQ ':Y.BEN.ACC:' AND BEN.BNK.CODE EQ ':Y.BEN.BNK
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.TEM)

    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS.ID
    WHILE Y.ID:POS.ID
        CALL F.READ(FN.REDO.ACH.TRANSFER.DETAILS,Y.ID,R.REDO.ADM.CHQ,F.REDO.ACH.TRANSFER.DETAILS,ERR.AD)
        R.REDO.ADM.CHQ<REDO.ACH.TRANS.ACH> = 'YES'
        CALL F.WRITE(FN.REDO.ACH.TRANSFER.DETAILS,Y.ID,R.REDO.ADM.CHQ)
    REPEAT

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:

END
