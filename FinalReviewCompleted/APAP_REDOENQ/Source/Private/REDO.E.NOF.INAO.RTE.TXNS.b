$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.INAO.RTE.TXNS(ENQ.DETAILS)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.E.NOF.INAO.RTE.TXNS
* ODR NUMBER    : ODR-2009-10-0472
*-------------------------------------------------------------------------

* Description : This routine is used to fetch the Ids of FT,Teller for the No file Enquiry REDO.INAO.RTE.TXNS

* In parameter : None
* out parameter : None

*----------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE                    DESCRIPTION
*                Ganesh R          ODR-2009-10-0472            INITIAL CREATION
* 22 July 2010   Shiva Prasad Y    ODR-2009-10-0318 B.126     Added TFS exception selection
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_ENQUIRY.COMMON

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

OPEN.FILES:

*Opening Files

    FN.TELLER='F.TELLER$NAU'
    F.TELLER=''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.FT='F.FUNDS.TRANSFER$NAU'
    F.FT=''
    CALL OPF(FN.FT,F.FT)

* Modification start - ODR-2009-10-0318 B.126 dated on 22 July 2010

    FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES$NAU'
    F.T24.FUND.SERVICES  = ''
    CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)

* Modification end - ODR-2009-10-0318 B.126 dated on 22 July 2010
RETURN

PROCESS:
* Fetching the ID's
*
* 20121112 - VNL - B.30 / S
    Y.USER.ID  = ""
    Y.USER.ID  = ENQ.SELECTION<4,Y.USER.POS>
*
    LOCATE "TXN.REF" IN D.FIELDS<1> SETTING Y.USER.POS THEN
*        Y.USER.ID  = D.RANGE.AND.VALUE<Y.USER.POS>
* 20121112 - VNL - B.30 / E
        Y.ID=Y.USER.ID[1,2]
        IF Y.ID EQ 'TT' THEN
            TT.SEL.CMD="SELECT ":FN.TELLER: " WITH @ID EQ ":Y.USER.ID: " WITH RECORD.STATUS EQ INAO AND L.RTE.FORM EQ YES"
            CALL EB.READLIST(TT.SEL.CMD,TT.SEL.LIST,'',NO.OF.REC,DATA.ERR)

            ENQ.DETAILS<-1>=TT.SEL.LIST
        END
        IF Y.ID EQ 'FT' THEN
            FT.SEL.CMD="SELECT ":FN.FT: " WITH @ID EQ ":Y.USER.ID: " WITH RECORD.STATUS EQ INAO AND L.RTE.FORM EQ YES"
            CALL EB.READLIST(FT.SEL.CMD,FT.SEL.LIST,'',NO.OF.REC,DATA.ERR)
            ENQ.DETAILS<-1>=FT.SEL.LIST
        END
    END ELSE
        TT.SEL.CMD="SELECT ":FN.TELLER: " WITH RECORD.STATUS EQ INAO AND L.RTE.FORM EQ YES"
        CALL EB.READLIST(TT.SEL.CMD,TT.SEL.LIST,'',NO.OF.REC,DATA.ERR)
        ENQ.DETAILS<-1>=TT.SEL.LIST
        FT.SEL.CMD="SELECT ":FN.FT: " WITH RECORD.STATUS EQ INAO AND L.RTE.FORM EQ YES"
        CALL EB.READLIST(FT.SEL.CMD,FT.SEL.LIST,'',NO.OF.REC,DATA.ERR)
        ENQ.DETAILS<-1>=FT.SEL.LIST

    END


* Modification start - ODR-2009-10-0318 B.126 dated on 22 July 2010

*    TFS.SEL.CMD="SELECT ":FN.T24.FUND.SERVICES: " WITH RECORD.STATUS EQ INAO AND L.RTE.FORM EQ YES"
*    CALL EB.READLIST(TFS.SEL.CMD,TFS.SEL.LIST,'',NO.OF.REC,DATA.ERR)
*    ENQ.DETAILS<-1>=TFS.SEL.LIST

* Modification end - ODR-2009-10-0318 B.126 dated on 22 July 2010
RETURN
END
