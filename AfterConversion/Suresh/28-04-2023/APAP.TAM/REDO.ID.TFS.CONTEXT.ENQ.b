* @ValidationCode : MjotMTU5MTI5NDQyNTpDcDEyNTI6MTY4MjY2MTM2MjExMjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Apr 2023 11:26:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.ID.TFS.CONTEXT.ENQ
*-------------------------------------------------------
*Description: This routine is to trigger the context enquiry from
*             TFS authorisation version.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.REDO.TFS.PROCESS
    $INSERT I_F.T24.FUND.SERVICES

    IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
        GOSUB INIT
        GOSUB PROCESS
    END

RETURN
*-------------------------------------------------------
INIT:
*-------------------------------------------------------

    FN.T24.FUND.SERVICES$NAU = 'F.T24.FUND.SERVICES$NAU'
    F.T24.FUND.SERVICES$NAU  = ''
    CALL OPF(FN.T24.FUND.SERVICES$NAU,F.T24.FUND.SERVICES$NAU)

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
    F.T24.FUND.SERVICES  = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

    FN.REDO.TFS.PROCESS = 'F.REDO.TFS.PROCESS'
    F.REDO.TFS.PROCESS  = ''
    CALL OPF(FN.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS)


    LOC.REF.APPL   = 'T24.FUND.SERVICES'
    LOC.REF.FIELDS = 'L.FT.ADD.INFO'
    LOC.REF.POS    = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.FT.ADD.INFO = LOC.REF.POS<1,1>

    Y.COS.NAME    = OFS$WINDOW.NAME
    Y.CASHIER.COS = 'TXNS'
    Y.SUPER.COS   = 'OFFICERTXNS'
    Y.BUSS.COS    = 'BUSINESSTXN'
RETURN
*-------------------------------------------------------
PROCESS:
*-------------------------------------------------------
    Y.TFS.ID          = COMI
    CALL F.READ(FN.T24.FUND.SERVICES$NAU,Y.TFS.ID,R.TFS,F.T24.FUND.SERVICES$NAU,TFS.ERR)

    IF R.TFS ELSE
        CALL F.READ(FN.T24.FUND.SERVICES,Y.TFS.ID,R.TFS,F.T24.FUND.SERVICES,TFS.ERR)
    END


    Y.PRIMARY.ACCOUNT = R.TFS<TFS.PRIMARY.ACCOUNT>
    IF Y.PRIMARY.ACCOUNT EQ '' OR ALPHA(Y.PRIMARY.ACCOUNT[1,3]) THEN
        IF PGM.VERSION EQ ',SERVICE.CREATE' THEN
            Y.PRIMARY.ACCOUNT = R.TFS<TFS.LOCAL.REF,POS.L.FT.ADD.INFO>
            IF Y.PRIMARY.ACCOUNT EQ '' THEN   ;* In case of drilling down from the enq REDO.TFS.PROCESS.LIST.
                Y.REDO.TFS.PROCESS.ID = FIELD(System.getVariable("CURRENT.ID"),"*",1)
                CALL F.READ(FN.REDO.TFS.PROCESS,Y.REDO.TFS.PROCESS.ID,R.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS,PRO.ERR)
                Y.PRIMARY.ACCOUNT = R.REDO.TFS.PROCESS<TFS.PRO.PRIMARY.ACCT>
            END
        END ELSE
            RETURN
        END
    END

    IF (Y.COS.NAME[1,4] EQ Y.CASHIER.COS OR Y.COS.NAME[1,11] EQ Y.SUPER.COS OR Y.COS.NAME[1,11] EQ Y.BUSS.COS) AND Y.PRIMARY.ACCOUNT THEN
        GOSUB GET.CONTEXT.ADDIT
    END


RETURN
* ----------------
GET.CONTEXT.ADDIT:
* ----------------
*
    GET.ENQ.LIST = 'ENQ REDO.ACCT.JHOLDER @ID EQ ':Y.PRIMARY.ACCOUNT
    GET.ENQ.LIST<-1> = 'ENQ REDO.ENQ.RBHP.PADRONE ACCOUNT.NO EQ ':Y.PRIMARY.ACCOUNT
    GET.ENQ.LIST<-1> = 'ENQ REDO.IM.CONSULTA.FIRMAS IMAGE.REFERENCE EQ ':Y.PRIMARY.ACCOUNT
    IF Y.COS.NAME[1,11] EQ Y.SUPER.COS THEN
        GET.ENQ.LIST<-1> = 'ENQ REDO.CUST.ACCT.FULL.CASH @ID EQ ':Y.PRIMARY.ACCOUNT
    END

    Y.CNT = 1 ; Y.ENQ.CNT = DCOUNT(GET.ENQ.LIST,@FM) ;

    LOOP
    WHILE I LE Y.ENQ.CNT
        Y.NEXT.TASK = ''
        Y.NEXT.TASK = GET.ENQ.LIST<I>
        CALL EB.SET.NEW.TASK(Y.NEXT.TASK)
        I += 1
    REPEAT

RETURN
END
