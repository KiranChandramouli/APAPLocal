* @ValidationCode : MjotNjkzNDU0OTMzOkNwMTI1MjoxNjg0NDkxMDI1MTI4OklUU1M6LTE6LTE6NjU4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 658
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*24-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  NO CHANGE
*24-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE AA.GET.RATE.CHANGE
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : AA.GET.RATE.CHANGE
*-------------------------------------------------------------------------

* Description :This routine is an Authorisation routine which is attached
* to the Versions of AZ.ACCOUNT, ACCOUNT.CREDIT.INT and GROUP.CREDIT.INT
* This Routine will update the Amendments whichever happening for GCI,
* ACI or AZ.ACCOUNT Records with Today.s System date in a Concat Table
* Called TAM.T.AUTH.COLLATERAL. This Routine should have a Valid Entry in
* PGM.FILE and EB.API

* Linked with : Version AZ.ACCOUNT,ACI,GCI
* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.GROUP.CREDIT.INT
    $INSERT I_F.REDO.L.AUTH.COLLATERAL

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-------------------------------------------------------------------------
INIT:
    FN.AUTH.COLLATERAL='F.REDO.L.AUTH.COLLATERAL'
    F.AUTH.COLLATERAL=''
    Y.ID=''
    Y.DATE=''
    R.AUTH.COLLATERAL=''
    R.LOC.AUTH.COLLATERAL=''
RETURN
*-------------------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------------------
    CALL OPF(FN.AUTH.COLLATERAL,F.AUTH.COLLATERAL)
RETURN
*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------

    BEGIN CASE
        CASE APPLICATION EQ 'GROUP.CREDIT.INT'
            Y.ID=LEN(ID.NEW)-7
            Y.DATE=ID.NEW[Y.ID,8]
            IF R.NEW(IC.GCI.CR.INT.RATE) NE R.OLD(IC.GCI.CR.INT.RATE) THEN
                GOSUB GCI.UPD
            END
        CASE APPLICATION EQ 'ACCOUNT.CREDIT.INT'
            Y.DATE=FIELD(ID.NEW,"-",2)
            IF R.NEW(IC.ACI.CR.INT.RATE) NE R.OLD(IC.ACI.CR.INT.RATE) THEN
                GOSUB ACI.UPD
            END
        CASE APPLICATION EQ 'AZ.ACCOUNT'
            Y.SCHDLE.TYPE=R.NEW(AZ.TYPE.OF.SCHDLE)
            LOCATE 'R' IN Y.SCHDLE.TYPE<1,1> SETTING POS THEN
                IF R.NEW(AZ.SCH.FIXED.RATE)<1,POS> NE R.OLD(AZ.SCH.FIXED.RATE)<1,POS> THEN
                    GOSUB AZACC.UPD
                END
            END
    END CASE
RETURN
*********
GCI.UPD:
*********
    IF Y.DATE LE TODAY THEN
        CALL F.READ(FN.AUTH.COLLATERAL,TODAY,R.AUTH.COLLATERAL,F.AUTH.COLLATERAL,AUTH.COLLATERAL.ERR)
        LOCATE ID.NEW IN R.AUTH.COLLATERAL<INT.AUTH.GCI,1> SETTING POS ELSE
            R.AUTH.COLLATERAL<INT.AUTH.GCI,-1> = ID.NEW
            CALL F.WRITE(FN.AUTH.COLLATERAL,TODAY,R.AUTH.COLLATERAL)
        END
    END
RETURN
**********
ACI.UPD:
**********
    IF Y.DATE LE TODAY THEN
        CALL F.READ(FN.AUTH.COLLATERAL,TODAY,R.AUTH.COLLATERAL,F.AUTH.COLLATERAL,AUTH.COLLATERAL.ERR)
        LOCATE ID.NEW IN R.AUTH.COLLATERAL<INT.AUTH.ACI,1> SETTING POS ELSE
            R.AUTH.COLLATERAL<INT.AUTH.ACI,-1> = ID.NEW
            CALL F.WRITE(FN.AUTH.COLLATERAL,TODAY,R.AUTH.COLLATERAL)
        END
    END
RETURN
**************
AZACC.UPD:
***************
    CALL F.READ(FN.AUTH.COLLATERAL,TODAY,R.AUTH.COLLATERAL,F.AUTH.COLLATERAL,AUTH.COLLATERAL.ERR)
    LOCATE ID.NEW IN R.AUTH.COLLATERAL<INT.AUTH.AZ.ACCOUNT,1> SETTING POS.ID ELSE
        R.AUTH.COLLATERAL<INT.AUTH.AZ.ACCOUNT,-1> = ID.NEW
        CALL F.WRITE(FN.AUTH.COLLATERAL,TODAY,R.AUTH.COLLATERAL)
    END
RETURN
******************************************************************************************
END
